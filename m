Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab3ANIHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:07:32 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:38609 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab3ANIHb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:07:31 -0500
From: Fabio Coatti <fabio.coatti@gmail.com>
To: joeyli <jlee@suse.com>
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>,
        MaChen@suse.com
Subject: Re: rf kill button not working on hp folio 9470m - bisected
Date: Mon, 14 Jan 2013 09:07:27 +0100
Message-ID: <1703448.HzxCQ2tOAu@calvin>
User-Agent: KMail/4.9.5 (Linux/3.7.2; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1668082.DN2GrHmhxH@calvin>
References: <CADpTngVYgS1nefgYO+fpBWkQ+XvvdE7RL1kV5cP4TLsKkU2i-Q@mail.gmail.com> <1358131527.6113.428.camel@linux-s257.site> <1668082.DN2GrHmhxH@calvin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data lunedì 14 gennaio 2013 08:59:55, Fabio Coatti ha scritto:
> > hmm... this machine changed wlan0 status on working kernel and also emit
> > e078 code like on Windows 8 mode.
> > 
> > Then I think your machine control RF power by different way but BIOS,
> > maybe wmi or other ways.
> > 
> > Please attached on your DSDT, hope OEM do those things through ACPI.
> 
> Done; I've tried to recompile it with iasl and I've got hundreds of errors,
> not a good sign I fear. I'll try to upgrade the firmware, even last time I
> tried the operation failed.
> 
> > Please try acpi_osi="!Windows 2012", it will switch back to Windows 2009
> > mode. Then look at does things better than before?
> > 
> > 
> > Thanks a lot!
> > Joey Lee
> 
> Will do that right now and report asap.
> Many thanks for the answer!

Ok, just tried; I can confirm that with acpi_osi="!Windows 2012" the rfkill 
works again, as it worked before the commit reported. 
Incidentally, it also fixes the issue with lcd backlight that I reported 
before.

 
--
Fabio
