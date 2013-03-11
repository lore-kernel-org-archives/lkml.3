Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3CKR2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:28:55 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:47310 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752063Ab3CKR2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:28:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19x/dFrk6GnVBHrN1bHFCWO
Date: Mon, 11 Mar 2013 10:28:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] ARM: smp_twd: Divorce smp_twd from local timer
 API
Message-ID: <20130311172847.GP26093@atomide.com>
References: <20130308004011.GD11806@atomide.com>
 <51393B59.3070200@codeaurora.org>
 <20130308180730.GE11806@atomide.com>
 <513A2B20.30805@codeaurora.org>
 <20130308194802.GG11806@atomide.com>
 <513A40EF.8050403@codeaurora.org>
 <20130308200811.GJ11806@atomide.com>
 <513A4774.3040605@codeaurora.org>
 <20130308202947.GK11806@atomide.com>
 <513A8B22.5030008@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513A8B22.5030008@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Boyd <sboyd@codeaurora.org> [130308 17:10]:
> On 03/08/13 12:29, Tony Lindgren wrote:
> > Applying that does not seem to help, but you might want to get vexpress
> > running anyways for some multiplatform sanity checks.
> >
> > I just built and installed qemu-linaro from their git, then ran the
> > command above. Looks like stock qemu does not work for vexpress for some
> > reason. You can probably use a dummy initrd and rootfs to debug this
> > though :)
> 
> So my patchset didn't break qemu?

Sorry if that was unclear: Yes your patchset breaks booting vexpress
in qemu.

What I meant earlier is that I've ever gotten the qemu-linaro to boot
vexpress and the unpatches qemu did not seem to boot vexpress at all
the last time I tried few months back.

Regards,

Tony
