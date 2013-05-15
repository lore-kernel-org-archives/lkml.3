Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab3EOMuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:50:51 -0400
Received: from tango.0pointer.de ([85.214.72.216]:57212 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3EOMuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:50:50 -0400
Date: Wed, 15 May 2013 14:50:48 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Jeremiah Foster <jeremiah.foster@pelagicore.com>
Cc: "Mehaffey, John" <John_Mehaffey@mentor.com>,
        "systemd-devel@lists.freedesktop.org" 
	<systemd-devel@lists.freedesktop.org>,
        "wd@denx.de" <wd@denx.de>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        "Kay.Sievers@vrfy.org" <Kay.Sievers@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "u-boot@lists.denx.de" <u-boot@lists.denx.de>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>,
        "genivi-dev@mail.genivi.org" <genivi-dev@mail.genivi.org>,
        "celinux-dev@lists.celinuxforum.org" 
	<celinux-dev@lists.celinuxforum.org>,
        "Pomerantz, Brian" <Brian_Pomerantz@mentor.com>,
        "yoush@cs.msu.su" <yoush@cs.msu.su>
Subject: Re: [systemd-devel] 2013 Plumber's CFP: Fastboot
Message-ID: <20130515125048.GC2206@tango.0pointer.de>
References: <371E240E6FC1D44DA5E51EE9DCDCB7845E3D0BF9@NA-MBX-03.mgc.mentorg.com>
 <CADVDRBjOX2Jy5t36jwZt9i9OGt3Ca_rBx_FbptYJ34CK2EP+AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVDRBjOX2Jy5t36jwZt9i9OGt3Ca_rBx_FbptYJ34CK2EP+AA@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15.05.13 11:43, Jeremiah Foster (jeremiah.foster@pelagicore.com) wrote:

> On Tue, May 14, 2013 at 1:51 AM, Mehaffey, John <John_Mehaffey@mentor.com>wrote:
> 
> > Hello All,
> >
> 
> Hey John!
> 
> 
> > I am proposing a microconference on fastboot at the Linux Plumber's
> > conference 2013 in New Orleans. The goal is to get to sub 1S boot times for
> > a large (IVI) system using NAND flash. This pushes the state of the art,
> > and will require innovative solutions in may areas of Linux plumbing,
> > including bootloader, kernel init, UBI, and systemd.
> >
> > Note that fastboot improvements will (generally) help all architectures so
> > I am not limiting this to automotive systems.
> >
> > Please visit http://wiki.linuxplumbersconf.org/2013:fastboot for more
> > information or if you want to submit a topic.
> >
> 
> I've linked to your micrconference from the automotive microconference:
> http://wiki.linuxplumbersconf.org/2013:automotive
> 
> I'm a bit confused about the LPC format though. John, is it planned to have
> the non-Android fastboot discussion as part of the automotive
> microconference or is this separate (despite its automotive relevance.) I
> ask because it might be nice to have the participants in both
> microconferences and it would be a shame to lose attendees to one or the
> other if they're competing tracks.
> 
> Can someone clue me in to the microconference format as regards LPC?


BTW, there's also this MC we proposed:

http://wiki.linuxplumbersconf.org/2013:boot_and_core_os

which sounds pretty close to fastboot?

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
