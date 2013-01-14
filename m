Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab3ANL0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:26:54 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:38121 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3ANL0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:26:52 -0500
From: Fabio Coatti <fabio.coatti@gmail.com>
To: joeyli <jlee@suse.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Bob Moore <robert.moore@intel.com>,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>,
        Tom St Denis <tstdenis@elliptictech.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: 3.7.X vs 3.6.11 HP Folio 9470m brightness regression?
Date: Mon, 14 Jan 2013 12:26:47 +0100
Message-ID: <5712575.oJ4QknpJbe@calvin>
User-Agent: KMail/4.9.5 (Linux/3.7.2; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358157059.14569.16.camel@linux-s257.site>
References: <1520620637.200975.1355955029721.JavaMail.root@elliptictech.com> <CADpTngVJqvXfgnd2cMRFL49nt9so+dcwKos8cSLPRj6L0eEPMg@mail.gmail.com> <1358157059.14569.16.camel@linux-s257.site>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data lunedì 14 gennaio 2013 17:50:59, joeyli ha scritto:
> 於 一，2013-01-14 於 09:13 +0100，Fabio Coatti 提到：
> 
> > While looking at a different issue (rfkill), related to this commit:
> > ====
> > 
> > > a57f7f9175b8ccbc9df83ac13860488913115de4 is the first bad commit
> > > commit a57f7f9175b8ccbc9df83ac13860488913115de4
> > > Author: Bob Moore <robert.moore@intel.com>
> > > Date: Fri Aug 17 10:55:02 2012 +0800
> > > 
> > > ACPICA: Add Windows8/Server2012 string for _OSI method.
> > > This change adds a new _OSI string, "Windows 2012" for both Windows 8
> > > and Windows Server 2012.
> > > 
> > > >From Microsoft document "How to Identify the Windows Version in ACPI
> > > 
> > > by Using _OSI", July 13, 2012.
> > > 
> > > Signed-off-by: Bob Moore <robert.moore@intel.com>
> > > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > > Signed-off-by: Len Brown <len.brown@intel.com>
> > 
> > ====
> > 
> > I discovered that reverting this commit (or, as suggested by joeyli
> > <jlee@suse.com>, booting with acpi_osi="!Windows 2012" ) also fixes
> > the brightness issue. So it seems related to the same ACPI issue, now
> > I wonder how it's happened that I got the wrong commit while
> > bisecting. Sorry for the noise, now the issue is still there but makes
> > more sense ):)
> 
> Use "!Windows 2012" can fallback to Windows 2009 mode for workaround
> rkfill button and brightness issue on your machine, but we still have
> problem with Windows 2012 mode.
> 
> That means we need spend more time to trace the dsdt stuff for guess
> what's behavior on HP machine with Windows 8.
> 
> 
> Thanks a lot!
> Joey Lee

Just let me know if I can help in some way (always available for testing).

Many thanks.


--
Fabio
