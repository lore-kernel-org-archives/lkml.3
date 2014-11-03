Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaKCW6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:58:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:55881 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaKCW6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:58:45 -0500
Date: Mon, 3 Nov 2014 23:58:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel J Blueman <daniel@numascale.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH v3 3/5] Numachip: Add safe is-present function
In-Reply-To: <545807ED.5090804@numascale.com>
Message-ID: <alpine.DEB.2.11.1411032358060.5308@nanos>
References: <1414915813-2462-1-git-send-email-daniel@numascale.com> <1414915813-2462-3-git-send-email-daniel@numascale.com> <alpine.DEB.2.11.1411032044590.5308@nanos> <545807ED.5090804@numascale.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014, Daniel J Blueman wrote:

> On 11/04/2014 03:45 AM, Thomas Gleixner wrote:
> > On Sun, 2 Nov 2014, Daniel J Blueman wrote:
> > 
> > > Add safe function to check if Numachip is detected, to be used elsewhere.
> > 
> > I cannot find a use case for this. I guess this is a left over of the
> > earlier 2G change, right?
> 
> I left it in as it's common to apic_numachip.c and a Numachip2 patch series
> I'll present later.

Please move it to that series then.

Thanks,

	tglx
