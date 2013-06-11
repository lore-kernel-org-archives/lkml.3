Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab3FKGLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:11:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20774 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3FKGLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:11:07 -0400
X-AuditID: cbfee68f-b7f436d000000f81-c0-51b6bf6f388d
Message-id: <51B6BF6F.2000902@samsung.com>
Date: Tue, 11 Jun 2013 15:10:55 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RESEND][PATCH] cpufreq: stats: Add 'load_table' sysfs file to
 show accumulated data of CPU
References: <1370419882-16831-1-git-send-email-cw00.choi@samsung.com>
 <CAKohpon6fgft2KZgy3-w5TxDz=5JsVHhNdTPTF7ZUq9K-kGc3w@mail.gmail.com>
 <51B5C2E4.9060400@samsung.com>
 <CAKohpokSt1=cbeYFo-U_DF5Mr8WOFDkkQbyaHh5DqR0OHh+S7A@mail.gmail.com>
 <51B6B373.7040904@samsung.com>
 <CAKohpomNN=keppPeLLDor_6YpyOO19_fsbWZRE+w33DoVDBprw@mail.gmail.com>
In-reply-to: <CAKohpomNN=keppPeLLDor_6YpyOO19_fsbWZRE+w33DoVDBprw@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWyRsSkSDd//7ZAg90d0hZPm36wW5xtesNu
	8f7QM2aLy7vmsFl87j3CaHG7cQWbRf/CXiaLjV89HDg87lzbw+Zx+99jZo++LasYPR4tbmH0
	+LxJLoA1issmJTUnsyy1SN8ugSvj8dS9rAXNLBX79qU3MM5h7mLk5JAQMJE49OsbC4QtJnHh
	3nq2LkYuDiGBpYwSc7a0McEUbX06lR0isYhR4uGv04wgCSGBF4wSn2bFgNi8AloSb3d0gE1i
	EVCV+PThMCuIzQYU3//iBhuILSoQJrFy+hUWiHpBiR+T7wHZHBwiQDUvb6aCzGcWOM8osfv/
	ObDrhAWyJJbN+80KsesOk8THh9YgNqdAsETTzZ9gNzAL6Ejsb53GBmHLS2xe8xbqs2vsEr9+
	WELcIyDxbfIhsF0SArISmw5AlUhKHFxxg2UCo9gsJBfNQjJ1FpKpCxiZVzGKphYkFxQnpRcZ
	6xUn5haX5qXrJefnbmIExt7pf8/6dzDePWB9iDEZaOVEZinR5Hxg7OaVxBsamxlZmJqYGhuZ
	W5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTHQN6or3VPlxomjk2z2i6/X
	frKgd87riwEVD79eWf/4qYuf9NR1d7ZEmwbPP/Ro+ySubbllbv/CxMsDloSu4d3rd8XBZvp7
	h//5k1nmKyrxGLfwsbvM3zt3buqBFfN+MEjo+PVWi4q+OaCuES78+FGwwn8G6fy7bhc4/a/v
	z5ifzf3F5b2STZ8SS3FGoqEWc1FxIgCTVjKl0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd38/dsCDdZ9ErZ42vSD3eJs0xt2
	i/eHnjFbXN41h83ic+8RRovbjSvYLPoX9jJZbPzq4cDhcefaHjaP2/8eM3v0bVnF6PFocQuj
	x+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+Abpu
	mTlAtygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYMx5P3cta0MxSsW9f
	egPjHOYuRk4OCQETia1Pp7JD2GISF+6tZ+ti5OIQEljEKPHw12lGkISQwAtGiU+zYkBsXgEt
	ibc7OlhAbBYBVYlPHw6zgthsQPH9L26wgdiiAmESK6dfYYGoF5T4MfkekM3BIQJU8/JmKsh8
	ZoHzjBK7/58DO0JYIEti2bzfrBC77jBJfHxoDWJzCgRLNN38CXYDs4COxP7WaWwQtrzE5jVv
	mScwCsxCsmIWkrJZSMoWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO7WdSOxhXNlgc
	YhTgYFTi4U1g3BYoxJpYVlyZe4hRgoNZSYTXdDtQiDclsbIqtSg/vqg0J7X4EGMyMAQmMkuJ
	JucD005eSbyhsYmZkaWRuaGFkbE5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTBu27Do
	VnphWMKGzjvTtpT9d2hZmON+kTPJ92rw6h1/Nr8WX/u2YWNZTU+WNv+9/0+WpUdcrYx+oLZh
	a19SnqTrb9vCvKANDk92rV52UfzaGz2DzY83/lznuKmvUyjzsLScaO/hpNmX285d5o7WT/G9
	eqBQVaPP65DUV9ON/uzqb+cJyzpfsXJWYinOSDTUYi4qTgQA9v2+QzEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 02:22 PM, Viresh Kumar wrote:
> On 11 June 2013 10:49, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> I will modify this patch according to your comment
>> and then resend it after merged below patch.
>> - [PATCH] cpufreq: stats: Remove CONFIG_CPU_FREQ_STAT_DETAILS
> Hmm.. Maybe you can sent it without rebasing your patch over mine and
> we can rebase it over my patch later. So, that you don't end up waiting for
> my patches to be included.

OK, I understand.

Thanks,
Chanwoo Choi

