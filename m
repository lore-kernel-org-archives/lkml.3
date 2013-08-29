Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3H2KO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:14:26 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33468 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3H2KOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:14:22 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-92-521f1efcc9e6
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kyungmin.park@samsung.com, t.stanislaws@samsung.com, m.chehab@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ian.campbell@citrix.com, rob@landley.net, mturquette@linaro.org,
        tomasz.figa@gmail.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, s.nawrocki@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3 1/6] media: s5p-tv: Replace mxr_ macro by default dev_
Date: Thu, 29 Aug 2013 12:14:16 +0200
Message-id: <1562143.sxFLZnf0g9@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1377706384-3697-2-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377706384-3697-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377706384-3697-2-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t/xq7p/5OSDDP42SlhMWneAyWL+kXOs
	Fm96O1gsehdcZbM42/SG3WLT42usFgvblrBYXN41h82iZ8NWVosZ5/cxWdy+zGtxcZ28xek1
	p5gtll6/yGTxdMJFNosJ09eyWBxeATRt3cvpQNabdlaLVwfbWCzmtb9ktTg2Ywmjxapdfxgd
	xD3WzFvD6NHS3MPmseDzFXaP15MnMHr8XfWC2WPnrLvsHq9Wz2T1uHNtD5vH5iX1Hgff7WHy
	6NuyitHj8yY5j41zQwN4o7hsUlJzMstSi/TtErgyLq85yl4wgb1iwaIX7A2Md1i7GDk5JARM
	JDZ/aWODsMUkLtxbD2RzcQgJLGWUuNm1D8rpYpLY13AJrIpNQE3ic8MjMFtEwFTi3d1rYEXM
	AvtZJJ6uncQIkhAW8JX4cmwmO4jNIqAqsXnGWrA4r4CmRMPiBWDN/ALqEu+2PWXqYuTgEBVw
	kej7mwkS5hTwk1j6vQ1q8URGie6uw1C9ghI/Jt9jAbGZBeQl9u2fygpha0ms33mcaQKj4Cwk
	ZbOQlM1CUraAkXkVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkikf9nBuPiY1SFGAQ5GJR7e
	iN+yQUKsiWXFlbmHGCU4mJVEeN9yygcJ8aYkVlalFuXHF5XmpBYfYmTi4JRqYJze8OdAm8U9
	wa7jP5fJbyr/zLjg5UHH7gWtfyznHey2e/Gp8Ujk8fP8DzylonYxfYvSW9K37DaTjm2k9dwa
	94yK2htyd1+xG5cKJEf945xziuWeX4iVk4cAX/XlKN1Y3r0fOxL7shMMhCdIfi6zrtlxy/DL
	2f9i87IP51vvTf2kLabY+eeRphJLcUaioRZzUXEiAIChqKbSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On Wednesday 28 of August 2013 18:12:59 Mateusz Krawczuk wrote:
> Replace mxr_dbg, mxr_info and mxr_warn by generic solution.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  drivers/media/platform/s5p-tv/mixer.h           |  12 ---
>  drivers/media/platform/s5p-tv/mixer_drv.c       |  47 ++++++-----
>  drivers/media/platform/s5p-tv/mixer_grp_layer.c |   2 +-
>  drivers/media/platform/s5p-tv/mixer_reg.c       |   6 +-
>  drivers/media/platform/s5p-tv/mixer_video.c     | 100
> ++++++++++++------------ drivers/media/platform/s5p-tv/mixer_vp_layer.c 
> |   2 +-
>  6 files changed, 78 insertions(+), 91 deletions(-)

Although, this is a valid patch, I don't think it is related by any way to 
migration of S5PV210 to common clock framework. So, IMHO, this patch should 
be send separately, not as a part of this series.

Best regards,
Tomasz

