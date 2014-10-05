Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaJEVaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 17:30:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:52091 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaJEVaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 17:30:13 -0400
Date: Sun, 5 Oct 2014 23:30:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ben Hutchings <ben@decadent.org.uk>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86: Reject x32 executables if x32 ABI not
 supported
In-Reply-To: <1412386843.9388.176.camel@decadent.org.uk>
Message-ID: <alpine.DEB.2.11.1410052329160.4383@nanos>
References: <1410120305.6822.9.camel@decadent.org.uk> <1412386843.9388.176.camel@decadent.org.uk>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2014, Ben Hutchings wrote:

> Can one of you please respond to this patch?

Oops. Slipped through the cracks. Picked it up. Shouldn't it be tagged
for stable?

Thanks,

	tglx
