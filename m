Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161854Ab3DEIDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 04:03:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16496 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3DEIDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 04:03:00 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-4d-515e8532dad8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, FlorianSchandinat@gmx.de,
        s.trumtrar@pengutronix.de, plagnioj@jcrosoft.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <8984685.165951364521249756.JavaMail.weblogic@epml18>
 <515E75BC.20604@ti.com>
In-reply-to: <515E75BC.20604@ti.com>
Subject: Re: [PATCH RESEND] fbmon: use VESA_DMT_VSYNC_HIGH to fix typo
Date: Fri, 05 Apr 2013 17:02:57 +0900
Message-id: <002601ce31d3$fc25cfc0$f4716f40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xys6ejvKtNqWcSHOwEZPg6BF8nwACP94Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zY12j1rhAgynvpC3mrF/DZvHykKZF
	58xrjBaXF15itTjR94HV4vKuOWwW6x6+YLL49HEhi8X6+bfYHDg9PnyM83h14Q6Lx4kZv1k8
	+v8aePRtWcXocfzGdiaPz5vkAtijuGxSUnMyy1KL9O0SuDLetC1iKnjOWXH14ST2BsbX7F2M
	nBwSAiYSy159YoWwxSQu3FvP1sXIxSEksIxR4uq3iWwwRR//vARrEBKYzihx81UiRNEvRomV
	J9+AdbMJqEl8+XIYrEhEQEdi0qIeZpAiZoFzjBIN27pYILqjJeavbmfqYuTg4BRQkdh5wgwk
	LCzgJjH/41mwEhYBVYlLF28xgdi8ArYSHQ8b2CFsQYkfk++B1TALaEms33mcCcKWl9i85i0z
	yEgJAXWJR391IU4wkpg7cQ9UuYjEvhfvGEHOkRBo5ZDo+b2TGWKXgMS3yYdYIHplJTYdYIb4
	V1Li4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQ
	+J64g/H+AetDjMlA6ycyS4km5wPTQ15JvKGxmZGFqYmpsZG5pRlpwkrivOot1oFCAumJJanZ
	qakFqUXxRaU5qcWHGJk4OKUaGA8+eLY2Zeselb3b7XjOW356H8azNE30RsP3icVpMWvWhDUf
	z5UIePeWzf9LYGX1Rv69PkfWrmiSfbBkbzTLoYZDLya//XEm/9qN7511yydNeB9VlKk80V5p
	fqriz7O7Vv4JuljywnnVr870HduPVOrq9icVFpm4rA3P5Tp2806MaPy9y8siU8SVWIozEg21
	mIuKEwHAZDWKBQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t9jQV2j1rhAg7e/RS3mrF/DZvHykKZF
	58xrjBaXF15itTjR94HV4vKuOWwW6x6+YLL49HEhi8X6+bfYHDg9PnyM83h14Q6Lx4kZv1k8
	+v8aePRtWcXocfzGdiaPz5vkAtijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jFmvGlbxFTwnLPi6sNJ7A2Mr9m7GDk5JARMJD7+eQlli0lcuLeeDcQWEpjOKHHzVWIXIxeQ
	/YtRYuXJN6wgCTYBNYkvXw6DNYgI6EhMWtTDDFLELHCOUaJhWxcLRHe0xPzV7UxdjBwcnAIq
	EjtPmIGEhQXcJOZ/PAtWwiKgKnHp4i0mEJtXwFai42EDO4QtKPFj8j2wGmYBLYn1O48zQdjy
	EpvXvGUGGSkhoC7x6K8uxAlGEnMn7oEqF5HY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSia
	WpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcPJ5J7WBc2WBxiFGAg1GJhzejLzZQiDWxrLgy9xCj
	BAezkgjvTr64QCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OBya2vJJ4Q2MTMyNLIzMLIxNz
	c9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgzIhf9P9fkp9JrJWGr1nXnV7DtNcNLIej
	ZNRU2c2Xi+hOfuQdlsIk4szLfvvA7ddb2ysuGM16tcU08L/qLtVgg75ne8O+HF3b3HH77Y0D
	FSk3xbPvKqxTzQjj/PXjvOd34/BHVsmcysKVD0JfXCub3d4VmNimPjOsItC7UnBW0uk9Gao9
	cx4rsRRnJBpqMRcVJwIA2JUXDGIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 05, 2013 3:57 PM, Tomi Valkeinen wrote:
> 
> Hi,
> 
> On 2013-03-29 03:40, Jingoo Han wrote:
> > VESA_DMT_VSYNC_HIGH should be used instead of VESA_DMT_HSYNC_HIGH,
> > because FB_SYNC_VERT_HIGH_ACT is related to vsync, not to hsync.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > ---
> >  drivers/video/fbmon.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> > index 94ad0f7..7f67099 100644
> > --- a/drivers/video/fbmon.c
> > +++ b/drivers/video/fbmon.c
> > @@ -1400,7 +1400,7 @@ int fb_videomode_from_videomode(const struct videomode *vm,
> >  	fbmode->vmode = 0;
> >  	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)
> >  		fbmode->sync |= FB_SYNC_HOR_HIGH_ACT;
> > -	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)
> > +	if (vm->dmt_flags & VESA_DMT_VSYNC_HIGH)
> >  		fbmode->sync |= FB_SYNC_VERT_HIGH_ACT;
> >  	if (vm->data_flags & DISPLAY_FLAGS_INTERLACED)
> >  		fbmode->vmode |= FB_VMODE_INTERLACED;
> 
> I'll apply this to fbdev fixes.

Oh, thank you. :)

Best regards,
Jingoo Han

> 
>  Tomi
> 
> 


