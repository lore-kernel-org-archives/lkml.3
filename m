Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaJAI5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:57:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:36155 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaJAI53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:57:29 -0400
Date: Wed, 1 Oct 2014 10:57:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
cc: mingo@redhat.com, hpa@zytor.com, davej@redhat.com, hmh@hmh.eng.br,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86: Quark: Add legacy_cache_size and TLB comments
In-Reply-To: <542B4B16.6060401@nexus-software.ie>
Message-ID: <alpine.DEB.2.11.1410011040040.4455@nanos>
References: <1412120517-14738-1-git-send-email-pure.logic@nexus-software.ie> <alpine.DEB.2.11.1410010153590.4455@nanos> <542B4B16.6060401@nexus-software.ie>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014, Bryan O'Donoghue wrote:
> On 01/10/14 01:11, Thomas Gleixner wrote:
> On the substance.
> I'm certainly not trying to antagonise you here - I assumed you were
> *suggesting* to apply those comments directly ?
> Which is why I updated the sent patches with your comments - since they
> seemed more descriptive anyway - and sent back to the list.

That part is fine. What really annoyed me is the patch:

Subject: [PATCH] x86: Call identify_cpu() unconditionally once remove other
     callsites

which is a complete fail in all aspects. You should be able to figure
that out yourself easily:

Read the reviews of "[PATCH 1/3] x86: Bugfix bit-rot in the calling of
legacy_cache_size" again carefully. Then look at your patch, the
subject line and the changelog. It should be pretty obvious.

Thanks,

	tglx
