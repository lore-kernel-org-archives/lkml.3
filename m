Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3HBVZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:25:16 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:51204 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3HBVZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:25:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAPBO7TYOe3EAoWhhzwMH5o5qmDPw0dp0upWH=h62ruHR4m3A0g@mail.gmail.com>
References: <20130731162252.GC4724@pd.tnic>
	<CAPBO7TaPxa_13FBDE5Z=Aoa+ePPfLRH0+oWSQyEmO00xSfGqYg@mail.gmail.com>
	<CAMP44s1WMMXcGfF6Ta0CFthY3-7tkpqXEPx1iZhVU-XpS6KUWw@mail.gmail.com>
	<1544218.2BR9ul04Pj@vostro.rjw.lan>
	<CAMP44s16-_KA+3JPSzD1CrzcNCuCk4xjOvU6E=gVRxkKiAGr0Q@mail.gmail.com>
	<CAPBO7TZT3hX67aX-2aG5f2mcVqOyka2xbTPvMWvHzTG-x+UBLA@mail.gmail.com>
	<CAMP44s3018jWPywQixcgD2UuM58oKYgs+D=aADTQvTyZqJsULA@mail.gmail.com>
	<CAPBO7TYOe3EAoWhhzwMH5o5qmDPw0dp0upWH=h62ruHR4m3A0g@mail.gmail.com>
Date: Fri, 2 Aug 2013 16:25:12 -0500
Message-ID: <CAMP44s3VyEPK-veHD5kUUPQcDeAKP82tN_px+A6k+BgxXJ270A@mail.gmail.com>
Subject: Re: i915 backlight
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Josep Lladonosa <jlladono@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@alien8.de>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 3:11 PM, Josep Lladonosa <jlladono@gmail.com> wrote:
> "Before" means with previous kernels that worked with
>
> GRUB_CMDLINE_LINUX="acpi_osi=Linux acpi_backlight=vendor"

That's probably a different issue. You would need to bisect the problem.

> I have not checked this issue with acpi_osi="!Windows 2012".

Please do.

-- 
Felipe Contreras
