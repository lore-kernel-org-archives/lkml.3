Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3IWM04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:26:56 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23290 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3IWM0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:26:55 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-54-5240338ced1e
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: m.chehab@samsung.com, t.stanislaws@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/4] media: s5p-tv: clean-up and fixes
Date: Mon, 23 Sep 2013 14:26:41 +0200
Message-id: <1439143.k4bEV6oqux@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xa7q9xg5BBj9TLDbOWM9qcbbpDbvF
	psfXWC0u75rDZtGzYSurxcV18han15xitjj8pp3VYl77S1YHTo/NS+o9Dr7bw+TRt2UVo8fn
	TXIBLFFcNimpOZllqUX6dglcGX/7mlkLfnJUNG/qZm5g7GbvYuTkkBAwkViw7ywrhC0mceHe
	erYuRi4OIYGljBKzN01lh3C6mCS6j+wFq2ITUJP43PCIDcQWETCVeHf3GlgHs8AzRon9DyDG
	CgvYSjx68x/MZhFQlbh4ZSaQzcHBK6Ap0fXLCyTML6Au8W7bUyYQW1TAVeLTwo1gJZwCfhLf
	9iSDhIUEfCUWnjgBtpZXQFDix+R7LCA2s4C8xL79U1khbC2J9TuPM01gFJyFpGwWkrJZSMoW
	MDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJgK87GJceszrEKMDBqMTDG5FoHyTEmlhW
	XJl7iFGCg1lJhHeRokOQEG9KYmVValF+fFFpTmrxIUYmDk6pBka57gzNo10rHzzO5Mm2emrL
	9/+Bl2RPvkXtqYtHdsix+aYK5n666CV9e2mA6C8Xyd7Tss+S1vzd8N1l9e6c1fpmGTa3NCy/
	T7zXovKYsye4ku2Pzf2LFldudWUc2FO/9a5zsu6ipaqZhWvkX3Fn1HUsv7N7t2Hm8p7bVz7v
	PJmwS3l92TLpGg0lluKMREMt5qLiRAAo4c7OXgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On Saturday 21 of September 2013 17:00:45 Mateusz Krawczuk wrote:
> This patch series add restoring previous vpll rate after driver offs
> stream or recives error.
> It also replace mxr_info, mxr_dbg, mxr_warn and mxr_err macro
> by generic solution.
> 
> Mateusz Krawczuk (4):
>   media: s5p-tv: Replace mxr_ macro by default dev_
>   media: s5p-tv: Restore vpll clock rate
>   media: s5p-tv: Fix sdo driver to work with CCF
>   media: s5p-tv: Fix mixer driver to work with CCF
> 
>  drivers/media/platform/s5p-tv/mixer.h           |  12 ---
>  drivers/media/platform/s5p-tv/mixer_drv.c       |  81
> ++++++++++++------- drivers/media/platform/s5p-tv/mixer_grp_layer.c |  
> 2 +-
>  drivers/media/platform/s5p-tv/mixer_reg.c       |   6 +-
>  drivers/media/platform/s5p-tv/mixer_video.c     | 100
> ++++++++++++------------ drivers/media/platform/s5p-tv/mixer_vp_layer.c 
> |   2 +-
>  drivers/media/platform/s5p-tv/sdo_drv.c         |  39 +++++++--
>  7 files changed, 137 insertions(+), 105 deletions(-)

For the whole series:

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

