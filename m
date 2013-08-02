Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3HBGsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 02:48:41 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:36613 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3HBGsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 02:48:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAPBO7TaPxa_13FBDE5Z=Aoa+ePPfLRH0+oWSQyEmO00xSfGqYg@mail.gmail.com>
References: <20130731162252.GC4724@pd.tnic>
	<20130731163623.GD4724@pd.tnic>
	<1419236.138PcnXVBh@vostro.rjw.lan>
	<20130801080724.GA3448@nazgul.tnic>
	<51FB4B0A.7060706@intel.com>
	<CAPBO7TaPxa_13FBDE5Z=Aoa+ePPfLRH0+oWSQyEmO00xSfGqYg@mail.gmail.com>
Date: Fri, 2 Aug 2013 01:48:37 -0500
Message-ID: <CAMP44s1WMMXcGfF6Ta0CFthY3-7tkpqXEPx1iZhVU-XpS6KUWw@mail.gmail.com>
Subject: Re: i915 backlight
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Josep Lladonosa <jlladono@gmail.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Borislav Petkov <bp@alien8.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 1:25 AM, Josep Lladonosa <jlladono@gmail.com> wrote:
> Hello,
>
> I am using a Lenovo Edge E530 and, with kernel 3.11.0-rc3, I had to
> change to this parameter to the kernel boot:
>
>
> GRUB_CMDLINE_LINUX="acpi_osi=\"!Windows 2012\""

I think it's pretty obvious that for the time being we need to
blacklist a ton of machines so they boot without this OSI. In fact, in
might make sense to simply remove the OSI completely for all machines
(for now).

-- 
Felipe Contreras
