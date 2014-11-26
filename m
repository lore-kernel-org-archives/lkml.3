Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaKZJnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:43:37 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:57672 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbaKZJnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:43:35 -0500
Message-ID: <1416995014.29407.50.camel@x220>
Subject: Re: [PATCH] x86: defconfig: Enable CONFIG_FHANDLE
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Dave Jones <davej@redhat.com>, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 26 Nov 2014 10:43:34 +0100
In-Reply-To: <54751ACF.9050604@nod.at>
References: <1416958612-7448-1-git-send-email-richard@nod.at>
	 <20141125234326.GA10021@redhat.com> <54751ACF.9050604@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2014 09:43:34.0763 (UTC) FILETIME=[724753B0:01D0095D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 01:11 +0100, Richard Weinberger wrote:
> Am 26.11.2014 um 00:43 schrieb Dave Jones:
> > On Wed, Nov 26, 2014 at 12:36:52AM +0100, Richard Weinberger wrote:
> >  > systemd has a hard dependency on CONFIG_FHANDLE.
> >  > If you run systemd with CONFIG_FHANDLE=n it will somehow
> >  > boot but fail to spawn a getty or other basic services.
> >  > As systemd is now used by most x86 distributions it
> >  > makes sense to enabled this by default and save kernel
> >  > hackers a lot of value debugging time.
> > 
> > Perhaps also note this in the kconfig entry for it ?
> 
> I'm not sure if this helps a lot.
> But I can create patch (including for all other systemd dependencies).

How would people find these notes: by grepping Kconfig files for
"systemd"? Wouldn't it make more sense - if what Richard states is
correct - to just enable those dependencies by default (provided they
have no adverse effects for a, well, not too big group of x86 systems)?


Paul Bolle

