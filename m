Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbbA2NM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:12:59 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54190 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844AbbA2NMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:12:55 -0500
Message-ID: <1422537172.1835.4.camel@gmail.com>
Subject: Re: [PATCH v2] samsung-laptop: enable better lid handling
From: Julijonas Kikutis <julijonas.kikutis@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:SAMSUNG LAPTOP DR..." 
	<platform-driver-x86@vger.kernel.org>
Date: Thu, 29 Jan 2015 13:12:52 +0000
In-Reply-To: <20150129052021.GA115032@vmdeb7>
References: <1418332715-10547-1-git-send-email-julijonas.kikutis@gmail.com>
	 <1422365168-2428-1-git-send-email-julijonas.kikutis@gmail.com>
	 <20150129052021.GA115032@vmdeb7>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.10 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Patch is generally fine, thanks for addressing my comments. Prior to merging I
> always run checkpatch.pl just in case I missed anything obvious:
> 
> $ scripts/checkpatch.pl ~/samsung/01-lid-handling.patch 
> WARNING: Prefer kstrto<type> to single variable sscanf
> #219: FILE: drivers/platform/x86/samsung-laptop.c:900:
> +       if (!count || sscanf(buf, "%i", &value) != 1)
> +               return -EINVAL;
> 
> total: 0 errors, 1 warnings, 219 lines checked
> 
> Please always run checkpatch.pl. It isn't sufficient and doesn't catch
> everything, but it is a minimum bar kind of thing.

I did run checkpatch.pl but left sscanf to be consistent with
set_battery_life_extender and set_usb_charge functions. Nevertheless, I
have just sent the third version of the patch with sscanf changed to
kstrtoint.

Thank you.

Julijonas

