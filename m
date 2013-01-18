Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab3AREfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 23:35:33 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:8353 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3AREfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 23:35:31 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-9e-50f8d11236f0
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'amit kachhap'" <amit.kachhap@gmail.com>,
        "'Inderpal Singh'" <inderpal.singh@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
References: <1357642258-32421-1-git-send-email-inderpal.singh@linaro.org>
 <CADGdYn6=fztS_Z9UeQiRyfE3FTAq+XfuPSrY=fT7LOgU498QXQ@mail.gmail.com>
In-reply-to: <CADGdYn6=fztS_Z9UeQiRyfE3FTAq+XfuPSrY=fT7LOgU498QXQ@mail.gmail.com>
Subject: RE: [linux-pm] [PATCH] cpufreq: exynos: Show list of available
 frequencies
Date: Thu, 17 Jan 2013 20:35:17 -0800
Message-id: <00e301cdf535$38f933a0$aaeb9ae0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQEMVqaMt3UbyozEFaYNaqMV8ZOXKQFM00jQmcdV8jA=
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zQ12hiz8CDJ40q1g8bfrBbnF51xw2
	ixnn9zE5MHt83iQXwBjFZZOSmpNZllqkb5fAlbFz1j6mgivcFfOvrmNvYNzC2cXIySEhYCLR
	3nqaFcIWk7hwbz1bFyMXh5DAMkaJ+98OsMAUtd48yQ6RWMQo8fzCdKiqv4wSBzs+s4FUsQlo
	SBx+/4wdxBYRiJboXfSABaSIWWAmo8TmlROYQRJCAhMYJZbOUQCxOQWCJc7+3cUIYgsLhEpc
	PnQV7A4WAVWJZcdfg9XzClhKPHkzlQ3CFpT4Mfke2EnMAloSm7c1sULY8hKb17xlhjhVQWLH
	2deMEEdYSfxYtgKqRlxi0oOH7BDzBSS+TT4ENIcDqF5WYtMBZpA7JQS2sUusXXcT6mVJiYMr
	brAAXTsLyepZSFbPQrJ6FpIVCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmKExJzUDsaV
	DRaHGAU4GJV4eLnUfwQIsSaWFVfmHmKU4GBWEuFtPQgU4k1JrKxKLcqPLyrNSS0+xOgDdPlE
	ZinR5HxgOsgriTc0NjYxMzE1Mbc0NTfFIawkzst46kmAkEB6YklqdmpqQWoRzDgmDk6pBkam
	fzOenGBgapwlkmtx50x5FO/8mpv+2wMPrVjj2PH6+YM3DhJP0hLvK8bM8xMoLLly9myDnkby
	xnes/Xsqm5+o1qzju7gi6s15/pVKp+5rOnufKBXYNfXxgktv8+TZ7C5OZU8LnbCq0K190qMy
	wd+10zwy0l/xW1zec+X/y5Uf2Lf9/mFftChXiaU4I9FQi7moOBEAGTtbruYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgK7QxR8BBrM+yVk8bfrBbnF51xw2
	ixnn9zE5MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5ixc9Y+
	poIr3BXzr65jb2DcwtnFyMkhIWAi0XrzJDuELSZx4d56ti5GLg4hgUWMEs8vTIdy/jJKHOz4
	zAZSxSagIXH4/TOwDhGBaIneRQ9YQIqYBWYySmxeOYEZJCEkMIFRYukcBRCbUyBY4uzfXYwg
	trBAqMTlQ1dZQWwWAVWJZcdfg9XzClhKPHkzlQ3CFpT4MfkeC4jNLKAlsXlbEyuELS+xec1b
	ZohTFSR2nH3NCHGElcSPZSugasQlJj14yD6BUWgWklGzkIyahWTULCQtCxhZVjGKphYkFxQn
	peca6hUn5haX5qXrJefnbmIER/QzqR2MKxssDjEKcDAq8fByqf8IEGJNLCuuzD3EKMHBrCTC
	23oQKMSbklhZlVqUH19UmpNafIjRB+jTicxSosn5wGSTVxJvaGxiZmRpZGZhZGJujkNYSZyX
	8dSTACGB9MSS1OzU1ILUIphxTBycUg2MOik932fVbzN5YPe6f+FJGR3bi71y+WWVr36dnGqy
	ar1F0/W7u56sr1z/kP3hyxMWCzrF3sXMcvb0XLfjXdLWQ98fsnA+DBO6/kDy0bnAN3J/Wgul
	F4fxLN5axeElVLhUairD5GV/Th+YOP/5WjO+JwbltUy7b89nmz7pcNGCp/fMhN2jTix7dVeJ
	pTgj0VCLuag4EQCEAswgFQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amit kachhap wrote:
> 
> On Tue, Jan 8, 2013 at 2:50 AM, Inderpal Singh
> <inderpal.singh@linaro.org> wrote:
> > Add freq_attr attribute to show list of available frequencies.
> >
> > Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> > Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
> > Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
> > ---
> >  drivers/cpufreq/exynos-cpufreq.c |   13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-
> cpufreq.c
> > index 7012ea8..bc1e833 100644
> > --- a/drivers/cpufreq/exynos-cpufreq.c
> > +++ b/drivers/cpufreq/exynos-cpufreq.c
> > @@ -244,13 +244,26 @@ static int exynos_cpufreq_cpu_init(struct
> cpufreq_policy *policy)
> >         return cpufreq_frequency_table_cpuinfo(policy, exynos_info-
> >freq_table);
> >  }
> >
> > +static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
> > +{
> > +       cpufreq_frequency_table_put_attr(policy->cpu);
> > +       return 0;
> > +}
> > +
> > +static struct freq_attr *exynos_cpufreq_attr[] = {
> > +       &cpufreq_freq_attr_scaling_available_freqs,
> > +       NULL,
> > +};
> > +
> 
> This change looks fine. I guess this was posted before also but could
> not go mainline.
> Reviewed-by: Amit Daniel Kachhap<amit.daniel@samsung.com>
> 
Looks OK to me, applied.

Thanks.

- Kukjin

