Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaFCJrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:47:16 -0400
Received: from helium.waldemar-brodkorb.de ([89.238.66.15]:34342 "EHLO
	helium.waldemar-brodkorb.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbaFCJrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:47:15 -0400
Date: Tue, 3 Jun 2014 11:42:32 +0200
From: Waldemar Brodkorb <wbx@openadk.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Rabeeh Khoury <rabeeh@solid-run.com>, linux-kernel@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: oops on cubox-i (v3.15-rc4)
Message-ID: <20140603094231.GH4197@waldemar-brodkorb.de>
References: <20140509144438.GW14063@waldemar-brodkorb.de>
 <20140511002506.GN12708@titan.lakedaemon.net>
 <20140523101751.GH618@waldemar-brodkorb.de>
 <20140523143845.GD8664@titan.lakedaemon.net>
 <20140523154453.GY3693@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140523154453.GY3693@n2100.arm.linux.org.uk>
X-Operating-System: Linux 3.2.0-4-amd64 x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Again,
> > > > 
> > > > On Fri, May 09, 2014 at 04:44:38PM +0200, Waldemar Brodkorb wrote:
> > > > > Dear Kernel Hackers,
> > > > > 
> > > > > I am getting kernel oopses on my cubox-i (i2ultra) running
> > > > > Linux 3.15-rc4, when using the box as a samba server with 
> > > > > a local attached 8 GB usb stick. (it also happen with a smaller
> > > > > video on the micro-sd card)
> > > > > The oops happens while playing a movie (4 GB file) on a samba client 
> > > > > (macos x maverick macbook) via vlc (after 5-15 minutes). 
> > > > > 
> > > > > Both systems are connected to a gigabit ethernet switch.
> > > > > 
> > > > > The oops happens with ntfs-3g, ntfs, vfat and ext4 filesystem.

The problem is gone with rc7.
It seems just like a cold, after seven rc'ays it's gone.

Sorry for the noise.
        best regards
                Waldemar 
