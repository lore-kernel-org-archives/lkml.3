Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936740Ab3DHKle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:41:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63070 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056Ab3DHKlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:41:31 -0400
X-AuditID: cbfee68d-b7f786d000005188-45-51629edafb40
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@sisk.pl>
Cc: "'Viresh Kumar'" <viresh.kumar@linaro.org>, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <cover.1365079581.git.viresh.kumar@linaro.org>
 <1769336.FkfMpuXqqb@vostro.rjw.lan>
 <2ccd01ce3439$911b51b0$b351f510$%kim@samsung.com>
 <2166815.0SZ6SYhSDN@vostro.rjw.lan>
In-reply-to: <2166815.0SZ6SYhSDN@vostro.rjw.lan>
Subject: RE: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to
 drivers/cpufreq
Date: Mon, 08 Apr 2013 19:41:29 +0900
Message-id: <2cf001ce3445$a115eec0$e341cc40$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac40RUcQIfCCtr1BQo+kMtoL9uUukgAAEXBg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zoe6teUmBBjv2clu87p7NajFp3QEm
	i409n9ktnjb9YLd4f+gZs8Wmx9dYLS7vmsNm8bn3CKPFjPP7mCwOLG1nsZhy+AuLRf/CXiaL
	z4d3sVusvfsUqPerhwO/x5p5axg9/q56wexx59oeNo/NS+o9bv97zOzxaHELo8fnTXIB7FFc
	NimpOZllqUX6dglcGdOPyRQcYq7YsDKngfEYUxcjJ4eEgInEl8eTGSFsMYkL99azdTFycQgJ
	LGOU2P98KQtM0dHT+1kgEtMZJS7fX8QM4fxllFjQ0wo2ik1AQ+Lw+2fsXYwcHCIC6hLHToqA
	1DALLGaWeDfhDVTDLkaJGYevs4I0cAoYSMyatJARpEFYIFRi9xlTkDCLgKpEw4sbYDN5BWwl
	fnW+YoSwBSV+TL7HAlLODDR/ypRckDCzgLzE5jVvmUHCEkDhR391QcIiAkYS/y+tYoEoEZHY
	9+IdI8gFEgJbOCTmbJrJBLFKQOLb5EMsEL2yEpsOMEP8KylxcMUNlgmMErOQLJ6FsHgWksWz
	kGxYwMiyilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMkLfTuYLx9wPoQYzLQ9onMUqLJ+cC0
	klcSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxrs3
	NHz+CVauYXaYbuEz0deDe8Pcvvp8z/erTXl2V+rfEXp9PPiQQe/MN4Grpn/oKtJamjpXx8nd
	7p/q/DNiaqKWzKaSbHu3MnoIKzdFGU1xtflWIri2SaaE/fSu3sIbm3Z7xTx58K1yedzs1l9r
	udn0WS9/nPbYSevhjbMz2FKcbvjdqE84p8RSnJFoqMVcVJwIAGUSXywhAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsVy+t9jQd1b85ICDV6/ZrF43T2b1WLSugNM
	Fht7PrNbPG36wW7x/tAzZotNj6+xWlzeNYfN4nPvEUaLGef3MVkcWNrOYjHl8BcWi/6FvUwW
	nw/vYrdYe/cpUO9XDwd+jzXz1jB6/F31gtnjzrU9bB6bl9R73P73mNnj0eIWRo/Pm+QC2KMa
	GG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgO5WUihL
	zCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZMPyZTcIi5YsPKnAbGY0xdjJwc
	EgImEkdP72eBsMUkLtxbz9bFyMUhJDCdUeLy/UXMEM5fRokFPa1gHWwCGhKH3z9j72Lk4BAR
	UJc4dlIEpIZZYDGzxLsJb6AadjFKzDh8nRWkgVPAQGLWpIWMIA3CAqESu8+YgoRZBFQlGl7c
	AJvJK2Ar8avzFSOELSjxY/I9FpByZqD5U6bkgoSZBeQlNq95ywwSlgAKP/qrCxIWETCS+H9p
	FQtEiYjEvhfvGCcwCs1CMmgWwqBZSAbNQtKxgJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7u
	JkZw0nkmtYNxZYPFIUYBDkYlHl7JH4mBQqyJZcWVuYcYJTiYlUR4xWcmBQrxpiRWVqUW5ccX
	leakFh9iTAZ6cyKzlGhyPjAh5pXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUg
	tQhmCxMHp1QDY2lu1MuXri/s7ytMOvZV61BUtJLY1++Kuzr+MZzdyJa7+zHXO1PFgnsc8/iq
	+j1m/DWq8hHc9Ug95OTuDVnhi7JfPW57EMKYxrbgnn7Lyty6s319Orf0K9eqpnc0nQjuujD5
	gO3zHyKNDcWl+uck4z4f/r2g83dNRVLCLxflza+qs42TKowOKbEUZyQaajEXFScCAAUUez1+	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

[...]

> > >
> > > Well, I'm dropping it.  Please merge via the Samsung tree.
> > >
> > OK, I will.
> >
> > I got patch file from Viresh, and there is a sign from Rafael,
> > but it should be ack. So Rafael, let me use your ack on this patch when
> > I apply. If any problems, please let me know.
> 
> Since it was signed-off by me before, you can assume it's been ACKed as
> well.
> 
Thanks.

- Kukjin

