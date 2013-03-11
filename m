Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3CKOs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:48:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51376 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab3CKOsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:48:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Harald Arnesen <skogtun.linux@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [3.9-rc1] very poor interrupt responses
Date: Mon, 11 Mar 2013 15:55:27 +0100
Message-ID: <8120640.CfmLsjk846@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <513DAD5D.6040905@gmail.com>
References: <2663178.G2EStYDi2n@segfault.sh0n.net> <7791757.cgjzv69Ulu@vostro.rjw.lan> <513DAD5D.6040905@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 11, 2013 11:09:33 AM Harald Arnesen wrote:
> Rafael J. Wysocki [2013-03-11 04:38]:
> 
> > On Friday, March 08, 2013 02:12:33 PM Shawn Starr wrote:
> >> Hello folks,
> >>
> >> I am noticing since rc0 and now rc1, very poor interrupt handling. Keyboard response, mouse movements, display refreshing etc. General input/display sluggishness. Did something break IRQ handling somewhere? I need to validate if this happens with X not running also if it is i915 related somehow. The behavor is noticed in a console login however.
> > 
> > Please try to disable the intel_pstate driver by putting intel_pstate=disable
> > into the kernel's command line and see if that helps (you may also try to
> > compile the driver out).
> 
> I see the same problem on my Thinkpad T500, and I have
> X86_INTEL_PSTATE=n in my config.

Can you please open a Bugzilla entry at bugzilla.kernel.org and attach
the output of lspci -vvv, the contents of /proc/interrupts and
a boot dmesg log from the affected machine to it?  Ideally, both from a kernel
that doesn't have the problem and from the affected one.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
