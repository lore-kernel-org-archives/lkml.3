Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315Ab3EOPCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:02:00 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:46116 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3EOPB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:01:58 -0400
From: "Mehaffey, John" <John_Mehaffey@mentor.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Lennart Poettering <mzxreary@0pointer.de>
CC: Jeremiah Foster <jeremiah.foster@pelagicore.com>,
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
Subject: RE: [systemd-devel] 2013 Plumber's CFP: Fastboot
Thread-Topic: [systemd-devel] 2013 Plumber's CFP: Fastboot
Thread-Index: Ac5QL8BaNyuX4Q42TyivWIVMiXMwVABW5x4AAAaIggAAApDXAP//l9ig
Date: Wed, 15 May 2013 15:01:49 +0000
Message-ID: <371E240E6FC1D44DA5E51EE9DCDCB7845E3D32D3@NA-MBX-03.mgc.mentorg.com>
References: <371E240E6FC1D44DA5E51EE9DCDCB7845E3D0BF9@NA-MBX-03.mgc.mentorg.com>
 <CADVDRBjOX2Jy5t36jwZt9i9OGt3Ca_rBx_FbptYJ34CK2EP+AA@mail.gmail.com>
 <20130515125048.GC2206@tango.0pointer.de>,<CAKi4VA+ru8_h=NW_X49GNL06XinsboM_ZicD8Js73Mw7x-xphA@mail.gmail.com>
In-Reply-To: <CAKi4VA+ru8_h=NW_X49GNL06XinsboM_ZicD8Js73Mw7x-xphA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [147.34.91.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 15 May 2013 15:01:49.0057 (UTC) FILETIME=[20095F10:01CE517D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Lucas De Marchi [lucas.de.marchi@gmail.com]
> Sent: Wednesday, May 15, 2013 7:04 AM
>  
> On Wed, May 15, 2013 at 9:50 AM, Lennart Poettering
> <mzxreary@0pointer.de> wrote:
> > On Wed, 15.05.13 11:43, Jeremiah Foster (jeremiah.foster@pelagicore.com) wrote:
> >
> >> On Tue, May 14, 2013 at 1:51 AM, Mehaffey, John <John_Mehaffey@mentor.com>wrote:
> >>
> >> > Hello All,
> >> >
> >>
> >> Hey John!
> >>
> >>
> >> > I am proposing a microconference on fastboot at the Linux Plumber's
> >> > conference 2013 in New Orleans. The goal is to get to sub 1S boot times for
> >> > a large (IVI) system using NAND flash. This pushes the state of the art,
> >> > and will require innovative solutions in may areas of Linux plumbing,
> >> > including bootloader, kernel init, UBI, and systemd.
> >> >
> >> > Note that fastboot improvements will (generally) help all architectures so
> >> > I am not limiting this to automotive systems.
> >> >
> >> > Please visit http://wiki.linuxplumbersconf.org/2013:fastboot for more
> >> > information or if you want to submit a topic.
> >> >
> >>
> >> I've linked to your micrconference from the automotive microconference:
> >> http://wiki.linuxplumbersconf.org/2013:automotive
> >>
> >> I'm a bit confused about the LPC format though. John, is it planned to have
> >> the non-Android fastboot discussion as part of the automotive
> >> microconference or is this separate (despite its automotive relevance.) I
> >> ask because it might be nice to have the participants in both
> >> microconferences and it would be a shame to lose attendees to one or the
> >> other if they're competing tracks.
> >>
> >> Can someone clue me in to the microconference format as regards LPC?
> >
> >
> > BTW, there's also this MC we proposed:
> >
> > http://wiki.linuxplumbersconf.org/2013:boot_and_core_os
> >
> > which sounds pretty close to fastboot?
> >
> 
> What if we merge the proposals?
> 
> John, are you ok with proposing (some of) these topics in the "Boot
> and Core OS" track? I could help with the module-related part, too.
> 
> 
> Lucas De Marchi

Hi Lucas, Lennart,
I am fine with merging the two boot related sessions.  I did not want to have it be a topic in the automotive microconf, as I believe there is enough material for a couple of hours on fastboot alone.

It was not clear to me what topics might be in the boot and core os microconf, so I proposed fastboot as separate.

Jeremiah, you bring up a good point about overlapping interest, probably when a proposal is accepted, we will need to point out potential scheduling conflicts with other accepted microconfs to the program committee.

Sincerely,
John Mehaffey
Senior System Architect (Automotive)
Mentor Graphics Corporation
