Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab3HBWXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:23:04 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:42657 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3HBWXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:23:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP44s3VyEPK-veHD5kUUPQcDeAKP82tN_px+A6k+BgxXJ270A@mail.gmail.com>
References: <20130731162252.GC4724@pd.tnic>
	<CAPBO7TaPxa_13FBDE5Z=Aoa+ePPfLRH0+oWSQyEmO00xSfGqYg@mail.gmail.com>
	<CAMP44s1WMMXcGfF6Ta0CFthY3-7tkpqXEPx1iZhVU-XpS6KUWw@mail.gmail.com>
	<1544218.2BR9ul04Pj@vostro.rjw.lan>
	<CAMP44s16-_KA+3JPSzD1CrzcNCuCk4xjOvU6E=gVRxkKiAGr0Q@mail.gmail.com>
	<CAPBO7TZT3hX67aX-2aG5f2mcVqOyka2xbTPvMWvHzTG-x+UBLA@mail.gmail.com>
	<CAMP44s3018jWPywQixcgD2UuM58oKYgs+D=aADTQvTyZqJsULA@mail.gmail.com>
	<CAPBO7TYOe3EAoWhhzwMH5o5qmDPw0dp0upWH=h62ruHR4m3A0g@mail.gmail.com>
	<CAMP44s3VyEPK-veHD5kUUPQcDeAKP82tN_px+A6k+BgxXJ270A@mail.gmail.com>
Date: Sat, 3 Aug 2013 00:23:00 +0200
Message-ID: <CAPBO7TZsGPMtLgwGz7WvpdQdb2KXdRbR1Xqu8aCWYjb71faBGA@mail.gmail.com>
Subject: Re: i915 backlight
From: Josep Lladonosa <jlladono@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@alien8.de>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 August 2013 23:25, Felipe Contreras <felipe.contreras@gmail.com> wrote:
> On Fri, Aug 2, 2013 at 3:11 PM, Josep Lladonosa <jlladono@gmail.com> wrote:
>> "Before" means with previous kernels that worked with
>>
>> GRUB_CMDLINE_LINUX="acpi_osi=Linux acpi_backlight=vendor"
>
> That's probably a different issue. You would need to bisect the problem.
>
>> I have not checked this issue with acpi_osi="!Windows 2012".
>
> Please do.

Hello, checking with acpi_osi="!Windows 2012" in the cmdline for
kernel 3.11.0-rc3 (and without the section you gave for the xorg.conf)
i get:

- brightness can be set among 16 levels.
- brightness recovers fine after a standby.
- brightness can be managed before entering xorg (during lightdm
screen, in my case. With the configuration of xorg.conf and
video.brightness_switch_enabled=0 it is not possible, only until xorg
has started).

Josep

>
> --
> Felipe Contreras



-- 
--
Salutacions...Josep
--
