Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaFJX2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:28:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:55947 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaFJX2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:28:23 -0400
Date: Wed, 11 Jun 2014 01:28:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Zhouyi Zhou <zhouzhouyi@gmail.com>, mingo@redhat.com, x86@kernel.org,
        peterz@infradead.org, cpw@sgi.com, linux-kernel@vger.kernel.org,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH] x86/tlb_uv: Fixing some memory allocation failure in
 x86 UV
In-Reply-To: <53978E9F.1010003@zytor.com>
Message-ID: <alpine.DEB.2.10.1406110111300.5170@nanos>
References: <1402385723-23138-1-git-send-email-zhouzhouyi@gmail.com> <53978E9F.1010003@zytor.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, H. Peter Anvin wrote:

> On 06/10/2014 12:35 AM, Zhouyi Zhou wrote:
> > Fixing some memory allocation failure handling in x86 UV
> > 
> > Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> 
> Sorry, this really isn't enough description for this size of a patch.

Correction: This is not a proper description for any patch.

"some" is wrong to begin with.

Either we fix a particular issue or we address all of them, but "some"
means: We fixed a few, but we did not care about the rest.

Aside of that, I agree. The changelog is disjunct from the patch
itself.

Thanks,

	tglx


