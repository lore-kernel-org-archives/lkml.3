Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3GYKGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:06:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64097 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab3GYKGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:06:08 -0400
X-IronPort-AV: E=Sophos;i="4.89,742,1367942400"; 
   d="scan'208";a="8020428"
Message-ID: <51F0F7AD.5000408@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 18:02:21 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver/vga16fb.c: remove the unused variable "dev" of
 function vga16fb_destroy()
References: <51F09D5E.70304@cn.fujitsu.com> <CAMuHMdVxXLrUXQno+vtHQrT_mmc9C6q42HZ6F1TujLBeEZt+Mw@mail.gmail.com>
In-Reply-To: <CAMuHMdVxXLrUXQno+vtHQrT_mmc9C6q42HZ6F1TujLBeEZt+Mw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 18:03:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 18:04:02,
	Serialize complete at 2013/07/25 18:04:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 05:58 PM, Geert Uytterhoeven wrote:

> On Thu, Jul 25, 2013 at 5:37 AM, Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
>> Commit  e21d2170f36602ae2708 removed the unnecessary platform_set_drvdata(),
>> but left the variable "dev" unused, delete it.
> 
> When referring to another commit, please also include the oneline summary of
> the commit, to make it easier for people to see what it's about.

Got it, thanks for your reminder.:)

> 
> E.g. "Commit  e21d2170f36602ae2708 ("video: remove unnecessary
> platform_set_drvdata()") removed the unnecessary platform_set_drvdata(),
> but left the variable "dev" unused, delete it."

This is easier reading. I'll update it.

Regards,
Gu


> 
> Thanks!
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 


