Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061Ab3EOOEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:04:40 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:64973 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab3EOOEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:04:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130515125048.GC2206@tango.0pointer.de>
References: <371E240E6FC1D44DA5E51EE9DCDCB7845E3D0BF9@NA-MBX-03.mgc.mentorg.com>
 <CADVDRBjOX2Jy5t36jwZt9i9OGt3Ca_rBx_FbptYJ34CK2EP+AA@mail.gmail.com> <20130515125048.GC2206@tango.0pointer.de>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Wed, 15 May 2013 11:04:16 -0300
Message-ID: <CAKi4VA+ru8_h=NW_X49GNL06XinsboM_ZicD8Js73Mw7x-xphA@mail.gmail.com>
Subject: Re: [systemd-devel] 2013 Plumber's CFP: Fastboot
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Jeremiah Foster <jeremiah.foster@pelagicore.com>,
        "Mehaffey, John" <John_Mehaffey@mentor.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 9:50 AM, Lennart Poettering
<mzxreary@0pointer.de> wrote:
> On Wed, 15.05.13 11:43, Jeremiah Foster (jeremiah.foster@pelagicore.com) wrote:
>
>> On Tue, May 14, 2013 at 1:51 AM, Mehaffey, John <John_Mehaffey@mentor.com>wrote:
>>
>> > Hello All,
>> >
>>
>> Hey John!
>>
>>
>> > I am proposing a microconference on fastboot at the Linux Plumber's
>> > conference 2013 in New Orleans. The goal is to get to sub 1S boot times for
>> > a large (IVI) system using NAND flash. This pushes the state of the art,
>> > and will require innovative solutions in may areas of Linux plumbing,
>> > including bootloader, kernel init, UBI, and systemd.
>> >
>> > Note that fastboot improvements will (generally) help all architectures so
>> > I am not limiting this to automotive systems.
>> >
>> > Please visit http://wiki.linuxplumbersconf.org/2013:fastboot for more
>> > information or if you want to submit a topic.
>> >
>>
>> I've linked to your micrconference from the automotive microconference:
>> http://wiki.linuxplumbersconf.org/2013:automotive
>>
>> I'm a bit confused about the LPC format though. John, is it planned to have
>> the non-Android fastboot discussion as part of the automotive
>> microconference or is this separate (despite its automotive relevance.) I
>> ask because it might be nice to have the participants in both
>> microconferences and it would be a shame to lose attendees to one or the
>> other if they're competing tracks.
>>
>> Can someone clue me in to the microconference format as regards LPC?
>
>
> BTW, there's also this MC we proposed:
>
> http://wiki.linuxplumbersconf.org/2013:boot_and_core_os
>
> which sounds pretty close to fastboot?
>

What if we merge the proposals?

John, are you ok with proposing (some of) these topics in the "Boot
and Core OS" track? I could help with the module-related part, too.


Lucas De Marchi
