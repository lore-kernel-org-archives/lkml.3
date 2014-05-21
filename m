Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaEUNcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:32:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27476 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaEUNct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:32:49 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-22-537caaff1ab8
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@rjwysocki.net>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Jonghwan Choi'" <jhbird.choi@samsung.com>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>
References: <20140519125124.6504764d@canb.auug.org.au>
 <1911725.FzcK6v311f@vostro.rjw.lan>
 <013b01cf73c2$5bbe1fb0$133a5f10$@samsung.com>
 <3571098.myqhuVX7FX@vostro.rjw.lan>
In-reply-to: <3571098.myqhuVX7FX@vostro.rjw.lan>
Subject: RE: linux-next: manual merge of the pm tree with the samsung tree
Date: Wed, 21 May 2014 22:32:47 +0900
Message-id: <036a01cf74f9$275d2c10$76178430$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIIb85tTBjRSQiHf0XUouzoyVElVAHpY+vKAqTXd1oDBrskZpqcat0g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zfd3/q2qCDWbMU7C4/uU5q8WSZm6L
	y7vmsFkcXNjGaHHm9CVWi617r7JbbPzq4cDu0XjjBpvHnWt72Dy2XG1n8ejbsorR4/MmuQDW
	KC6blNSczLLUIn27BK6MB78WMBbs4qyYvPYRUwPjfPYuRk4OCQETia2/X7NC2GISF+6tZ+ti
	5OIQEljGKHHhyCYWmKI/cz8xQSQWMUqcejQHquovo8Tv6fuYQarYBDQkDr9/BjZWREBXouve
	LLBuZoFXjBKfGoIhGjYxSpx7uQOsiFPAQGL7ob1MILawgJfE17VtQHdwcLAIqErcuaoNEuYV
	sJS4/m8DO4QtKPFj8j2omeoSk+YtYoaw5SU2r3nLDHGpgsSOs68ZIW5wk1g15ydUvYjEvhfv
	GCFqXrJLPF/iAGKzCAhIfJt8iAVkrYSArMSmA1BjJCUOrrjBMoFRYhaSzbOQbJ6FZPMsJBsW
	MLKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiJ3d4djLcPWB9iTAZaP5FZSjQ5Hxj7eSXx
	hsZmRhamJqbGRuaWZqQJK4nzJj1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAeNzl4Sef
	V4vz/zk05t1RMzJw5Ystz1RIu7NCYnVL3L9vM5rdAs3evwgTmHTtIeeTTdauFmycL+oWsjg/
	vvnayS7qo3RsodA7RxPPx1qxRtOuaJtUhFzUKvRqvrVbq0ZsY/jv/2tYzW+x1spV+4VFOdWf
	Z34w84f4ytW87csv+6z30rj89qGdEktxRqKhFnNRcSIAIbdWPvMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAd3/q2qCDa69kLa4/uU5q8WSZm6L
	y7vmsFkcXNjGaHHm9CVWi617r7JbbPzq4cDu0XjjBpvHnWt72Dy2XG1n8ejbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGQ9+LWAs2MVZMXntI6YGxvns
	XYycHBICJhJ/5n5igrDFJC7cW8/WxcjFISSwiFHi1KM5UM5fRonf0/cxg1SxCWhIHH7/DKxb
	REBXouveLBYQm1ngFaPEp4ZgiIZNjBLnXu4AK+IUMJDYfmgv2AphAS+Jr2vbWLsYOThYBFQl
	7lzVBgnzClhKXP+3gR3CFpT4Mfke1Ex1iUnzFjFD2PISm9e8ZYa4VEFix9nXjBA3uEmsmvMT
	ql5EYt+Ld4wTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZG
	cGp4JrWDcWWDxSFGAQ5GJR7eBUXVwUKsiWXFlbmHGCU4mJVEeI2n1gQL8aYkVlalFuXHF5Xm
	pBYfYkwGenQis5Rocj4wbeWVxBsam5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUI
	ZgsTB6dUA+OSpY9Ybl9vWCn/xCtCxdL49WMxuX8V7KF8SwxuTGou2f/ogZrL8V89Jx/sPVfr
	8+PZ3YfvTR8+3KH2utQ7d2uW8ez7/isXVrvPe9Sir91jGKPHZ/dt/QfbuE2zLLpX+bxyzjnF
	U19y/XNW19Xs+XO1mjxme7k9NOvMlBcX27hi/5ovR5lNv8xWYinOSDTUYi4qTgQAlUKuh1ED	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> 
> On Tuesday, May 20, 2014 09:27:58 AM Kukjin Kim wrote:
> > Rafael J. Wysocki wrote:
> > >
> > > On Monday, May 19, 2014 12:51:24 PM Stephen Rothwell wrote:
> > > >
> > > > --Sig_/n+GoYBpTr9ERl.sTIEYr/Og
> > > > Content-Type: text/plain; charset=US-ASCII
> > > > Content-Transfer-Encoding: quoted-printable
> > > >
> > > > Hi Rafael,
> > > >
> > > > Today's linux-next merge of the pm tree got conflicts in
> > > > drivers/cpufreq/exynos-cpufreq.c and drivers/cpufreq/exynos-cpufreq.h
> > > > between commit 2b07f4085479 ("cpufreq: exynos: Fix the compile error")
> > > > from the samsung tree and commit e5eaa445b0dc ("cpufreq: exynos: Use
> > > > dev_err/info function instead of pr_err/info") from the pm tree.
> > > >
> > > > I fixed it up (see below) and can carry the fix as necessary (no
> action
> > > > is required).
> > >
> > > Thanks for fixing that Stephen!
> > >
> > Same here ;-)
> >
> > > Kukjin, are you going to handle all Exynos cpufreq commits in the future?
> > >
> > If you're OK, would be better to us I think.
> 
> OK, I'll leave them to you, then.  Please ask Viresh for ACKs if needed. :-)
> 
I will.

Thanks,
Kukjin

