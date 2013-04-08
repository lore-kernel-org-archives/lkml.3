Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934903Ab3DHJPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:15:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58710 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250Ab3DHJPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:15:11 -0400
X-AuditID: cbfee690-b7f656d0000007e3-8a-51628a9d7d5a
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <cover.1365079581.git.viresh.kumar@linaro.org>
 <2a5901ce31c9$95160980$bf421c80$%kim@samsung.com>
 <CAKohpokk1Q+0gRpeW=ts0a8D+rGAUpHu62X+7ejdpfom_B6FYA@mail.gmail.com>
 <1769336.FkfMpuXqqb@vostro.rjw.lan>
In-reply-to: <1769336.FkfMpuXqqb@vostro.rjw.lan>
Subject: RE: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to
 drivers/cpufreq
Date: Mon, 08 Apr 2013 18:15:09 +0900
Message-id: <2ccd01ce3439$911b51b0$b351f510$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4x8L/LH15QqI7MTUy7760jqfAMhwCOvMpw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zse7crqRAgy+L9Sxed89mtZi07gCT
	xcaez+wWT5t+sFu8P/SM2WLT42usFpd3zWGz+Nx7hNFixvl9TBYHlrazWEw5/IXFon9hL5PF
	58O72C3W3n0K1PvVw4HfY828NYwef1e9YPa4c20Pm8fmJfUet/89ZvZ4tLiF0ePzJrkA9igu
	m5TUnMyy1CJ9uwSujFNvn7MUHGer6N/g2cD4n6WLkZNDQsBEYt/rJYwQtpjEhXvr2boYuTiE
	BJYxSjy728oMU3Rx6jYWiMR0Rokb5/dCVf1llNg9dQcrSBWbgIbE4ffP2EFsEYFgiWs31jCB
	2MwCP5kkNi2Ng2i4zSgxYeJVsCJOAQOJ7hmfgJo5OIQFQiV2nzEFCbMIqEocXvOHDcTmFbCV
	+N0+nwnCFpT4MfkeC0g5s4C6xJQpuRDjtSWevLsANkUCKPzory6IKSJgJNH7SA2iQkRi34t3
	jCAHSAis5ZCY9mc2M8QmAYlvkw+xQLTKSmw6APWupMTBFTdYJjBKzEKydxbC3llI9s5CsmEB
	I8sqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjJC0MGEH470D1ocYk4G2T2SWEk3OB6aVvJJ4
	Q2MzIwtTE1NjI3NLM9KElcR51VusA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwaqrGXOE7
	/c7YWebCgjvXXtmb8xyeFr9uB3v4x7vPbDR4Zs29/79gD3Nnfk/JsecB6wPTmK5O9lWMM/Jo
	2M/wImijvh0rV2DTIbfnRavMJC5Lzi3+nXsrMfPGaW3Pjaaes6VDPiu0zujOVpG20FVK5Zp7
	4sGzJ49OdT67v5v7yt+l8ox6E5u2KLEUZyQaajEXFScCAOA7CA0hAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsVy+t9jQd25XUmBBqvbNSxed89mtZi07gCT
	xcaez+wWT5t+sFu8P/SM2WLT42usFpd3zWGz+Nx7hNFixvl9TBYHlrazWEw5/IXFon9hL5PF
	58O72C3W3n0K1PvVw4HfY828NYwef1e9YPa4c20Pm8fmJfUet/89ZvZ4tLiF0ePzJrkA9qgG
	RpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoLuVFMoS
	c0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmn3j5nKTjOVtG/wbOB8T9LFyMn
	h4SAicTFqdugbDGJC/fWs3UxcnEICUxnlLhxfi+U85dRYvfUHawgVWwCGhKH3z9jB7FFBIIl
	rt1YwwRiMwv8ZJLYtDQOouE2o8SEiVfBijgFDCS6Z3wCaubgEBYIldh9xhQkzCKgKnF4zR82
	EJtXwFbid/t8JghbUOLH5HssIOXMAuoSU6bkQozXlnjy7gLYFAmg8KO/uiCmiICRRO8jNYgK
	EYl9L94xTmAUmoVkziyEObOQzJmFpGMBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCk
	80xqB+PKBotDjAIcjEo8vJI/EgOFWBPLiitzDzFKcDArifA+rE0KFOJNSaysSi3Kjy8qzUkt
	PsSYDPTlRGYp0eR8YELMK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwW
	Jg5OqQZG9bOcPMFLWifNzH9sOXlh15KNth3f1LdKeqkVvo7QvfByi1P3xlfPM2su9k+eGOpt
	KPYxscRFqKN2R6fFkumsbEusXT9X3l3QdmxWpCnPpHQXrR/H1wTar/jpIvEswqosL2+L98JP
	GR41q1fu+1ZbHKHArf7bYertxo/PeS9qvQnVj54wm7NOiaU4I9FQi7moOBEA5ohelX4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> 
> On Friday, April 05, 2013 12:36:34 PM Viresh Kumar wrote:
> > On 5 April 2013 12:18, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > > Basically, this moving looks good to me, but should be re-worked based
> on
> > > for-next of samsung tree because this touches too many samsung stuff
> so this
> > > should be sent to upstream via samsung tree.
> >
> > Hmm... Its already applied in Rafael's tree. But it doesn't mean that
> > it can't be
> > moved to your tree if there is a issue.
> 
> Well, I'm dropping it.  Please merge via the Samsung tree.
> 
OK, I will.

I got patch file from Viresh, and there is a sign from Rafael, but it should be ack. So Rafael, let me use your ack on this patch when I apply. If any problems, please let me know.

Thanks.

- Kukjin

