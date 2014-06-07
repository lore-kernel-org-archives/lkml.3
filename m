Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaFGUSz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 16:18:55 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:56045 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaFGUSy (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 16:18:54 -0400
MIME-Version: 1.0
In-Reply-To: <53935504.1080903@symas.com>
References: <53935504.1080903@symas.com>
Date: Sun, 8 Jun 2014 06:18:52 +1000
Message-ID: <CAPM=9tz4oumjPD=bzBoJKkmhRA956a-FaNw2G+_zaO4kzWSEAQ@mail.gmail.com>
Subject: Re: 3.12.9 kern.log spam from vgaswitcheroo
From: Dave Airlie <airlied@gmail.com>
To: Howard Chu <hyc@symas.com>
Cc: Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexdeucher@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing list

On 8 June 2014 04:08, Howard Chu <hyc@symas.com> wrote:
> On Asus NP56D, if you use vgaswitcheroo to turn off the discrete GPU, the
> kernel starts spewing these messages endlessly, until /var/log partition
> fills up:
>
> Jun  7 17:40:27 gamba kernel: [470008.702322] [drm:radeon_cs_parser_init]
> *ERROR* VM not ac
> tive on asic!
> Jun  7 17:40:27 gamba kernel: [470008.702325] [drm:radeon_cs_ioctl] *ERROR*
> Failed to initi
> alize parser !
> Jun  7 17:40:27 gamba kernel: [470008.702385] [drm:radeon_cs_parser_init]
> *ERROR* VM not ac
> tive on asic!
> Jun  7 17:40:27 gamba kernel: [470008.702389] [drm:radeon_cs_ioctl] *ERROR*
> Failed to initi
> alize parser !
>
> Turning the discrete GPU back on stops the stream of messages.
> --
>   -- Howard Chu
>   CTO, Symas Corp.           http://www.symas.com
>   Director, Highland Sun     http://highlandsun.com/hyc/
>   Chief Architect, OpenLDAP  http://www.openldap.org/project/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
