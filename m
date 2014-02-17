Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaBQWvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:51:20 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49603 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178AbaBQWvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:51:18 -0500
X-Sasl-enc: 8/ceItibssPmKEgq3YymcdjLEYiid0+J5Tq8ENAxI+2R 1392677476
Date: Mon, 17 Feb 2014 19:51:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Jan Beulich <JBeulich@suse.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Issue a warning if number of present CPUs > maxcpus
 and CONFIG_HOTPLUG=n
Message-ID: <20140217225111.GA2561@khazad-dum.debian.net>
References: <20140215150223.63bb52fb@hananiah.suse.cz>
 <5301D7AA020000780011CBE9@nat28.tlf.novell.com>
 <20140217110402.7e4fc211@hananiah.suse.cz>
 <20140217134006.GA14786@khazad-dum.debian.net>
 <20140217151626.5ff99027@hananiah.suse.cz>
 <20140217190704.GA24390@khazad-dum.debian.net>
 <20140217203102.7af3fd28@hananiah.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217203102.7af3fd28@hananiah.suse.cz>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014, Petr Tesarik wrote:
> > I'd rather no warnings were printed at all (user asked for that nr_cpus,
> > there is no reason to warn him about it),
> >[...]
> 
> Agreed. This needs some cleanup.
> 
> This code used to check against NR_CPUS, which is a compile-time
> constant, so the warning was printed when the user booted a kernel
> incapable of using all available CPUs in the system. And this was a
> good thing, because there was no (easy) way to find out this constant
> from a given kernel binary.
> 
> I can post a clean-up patch that doesn't issue any warnings for user
> overrides (but does issue warnings for exceeding hard-coded kernel
> limits).

That'd be really nice.  Thank you!

> But I'll do it separately and only after I know if the current patch
> gets accepted or not. ;-)

:-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
