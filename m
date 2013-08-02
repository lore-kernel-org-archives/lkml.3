Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab3HBULb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 16:11:31 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:46889 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3HBUL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 16:11:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP44s3018jWPywQixcgD2UuM58oKYgs+D=aADTQvTyZqJsULA@mail.gmail.com>
References: <20130731162252.GC4724@pd.tnic>
	<CAPBO7TaPxa_13FBDE5Z=Aoa+ePPfLRH0+oWSQyEmO00xSfGqYg@mail.gmail.com>
	<CAMP44s1WMMXcGfF6Ta0CFthY3-7tkpqXEPx1iZhVU-XpS6KUWw@mail.gmail.com>
	<1544218.2BR9ul04Pj@vostro.rjw.lan>
	<CAMP44s16-_KA+3JPSzD1CrzcNCuCk4xjOvU6E=gVRxkKiAGr0Q@mail.gmail.com>
	<CAPBO7TZT3hX67aX-2aG5f2mcVqOyka2xbTPvMWvHzTG-x+UBLA@mail.gmail.com>
	<CAMP44s3018jWPywQixcgD2UuM58oKYgs+D=aADTQvTyZqJsULA@mail.gmail.com>
Date: Fri, 2 Aug 2013 22:11:27 +0200
Message-ID: <CAPBO7TYOe3EAoWhhzwMH5o5qmDPw0dp0upWH=h62ruHR4m3A0g@mail.gmail.com>
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

"Before" means with previous kernels that worked with

GRUB_CMDLINE_LINUX="acpi_osi=Linux acpi_backlight=vendor"

I have not checked this issue with acpi_osi="!Windows 2012".

Josep

On 2 August 2013 22:08, Felipe Contreras <felipe.contreras@gmail.com> wrote:
> On Fri, Aug 2, 2013 at 3:03 PM, Josep Lladonosa <jlladono@gmail.com> wrote:
>> With this setup, something has happened: in xorg, when screen goes to
>> screensaver and after, enters into Standby mode, when I press a key,
>> it keeps black and, to recover screen, I have to adjust brightness
>> manually (by increasing), as if it didn't remember previous value to
>> standby mode.
>>
>> This was something that before didn't happen.
>
> You mean with acpi_osi="!Windows 2012"? And when you say "before",
> what do you mean?
>
> --
> Felipe Contreras



-- 
--
Salutacions...Josep
--
