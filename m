Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbaD2Fur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 01:50:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61809 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbaD2Fup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 01:50:45 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-a1-535f3db41d48
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Viresh Kumar'" <viresh.kumar@linaro.org>
Cc: "'open list'" <linux-kernel@vger.kernel.org>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Len Brown'" <len.brown@intel.com>
References: <000601cf636b$3c2b39b0$b481ad10$@samsung.com>
 <CAOh2x=nzLNDe+vL5UvKkaRMDT7M+U9jG4HLHavS2ksmiOE_G+w@mail.gmail.com>
In-reply-to: <CAOh2x=nzLNDe+vL5UvKkaRMDT7M+U9jG4HLHavS2ksmiOE_G+w@mail.gmail.com>
Subject: RE: [PATCH 1/2] PM / OPP: Use list_for_each_entry_reverse instead of
 list_for_each_entry
Date: Tue, 29 Apr 2014 14:50:44 +0900
Message-id: <001301cf636e$f6032f70$e2098e50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJcKZ/vgGnbV8fp7NGNJtB8ItYdcgHzKemCmf7tKzA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zI90ttvHBBv1zFCxmTdnLZHF51xw2
	izOnL7FabPzq4cDisXjPSyaPO9f2sHlsudrO4vF5k1wASxSXTUpqTmZZapG+XQJXRuNyvoIL
	PBWNM48xNjB+4+xi5OSQEDCR2H7oHhOELSZx4d56ti5GLg4hgWWMEv3fNrLDFB34vZgRIjGd
	UeLs65/sEM4/Rom7q7Ywg1SxCehKHFu/hRXEFhHQkej/vQwszixQJ9G9+SXU2AZGib7Tj8ES
	nALBEl3nFoHZwgLJEvMam8HuYBFQlXh0fhJYnFfAUmLXpvesELagxI/J91gghmpJrN95nAnC
	lpfYvOYtM8SpChI7zr5mhDjCSqLz7GJGiBoRiX0v3oG9ICFwjF3i054pLBDLBCS+TT4EZHMA
	JWQlNh2AmiMpcXDFDZYJjBKzkKyehWT1LCSrZyFZsYCRZRWjaGpBckFxUnqRiV5xYm5xaV66
	XnJ+7iZGSFxO2MF474D1IcZkoPUTmaVEk/OBcZ1XEm9obGZkYWpiamxkbmlGmrCSOK/ao6Qg
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYziDr9C0jeL+7as4H69c8uv7bm83xrduvbcMxC5
	ey356Pvbs/8UcyZ8fre8wLP3kErFhJp9+64Jne9vm7G453jXUvt3corGRfNzpaZ9/r6q7ePv
	bvGua7PTXxpVu/44yeOadW3yUZ2prTtutp2ZvVSkZ8ml4zm3vjlNqf35xLJ+ugjfzuJ5acfK
	lViKMxINtZiLihMBkdyQj+ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jQd0ttvHBBq2rZCxmTdnLZHF51xw2
	izOnL7FabPzq4cDisXjPSyaPO9f2sHlsudrO4vF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY0bjcr6CCzwVjTOPMTYwfuPsYuTkkBAwkTjwezEjhC0mceHeerYu
	Ri4OIYHpjBJnX/9kh3D+MUrcXbWFGaSKTUBX4tj6LawgtoiAjkT/72VgcWaBOonuzS+huhsY
	JfpOPwZLcAoES3SdWwRmCwskS8xrbGYCsVkEVCUenZ8EFucVsJTYtek9K4QtKPFj8j0WiKFa
	Eut3HmeCsOUlNq95ywxxqoLEjrOvGSGOsJLoPAvxArOAiMS+F+8YJzAKzUIyahaSUbOQjJqF
	pGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCofya1g3Flg8UhRgEORiUeXoOouGAh
	1sSy4srcQ4wSHMxKIrz5VvHBQrwpiZVVqUX58UWlOanFhxiTgT6dyCwlmpwPTEh5JfGGxiZm
	RpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cC422d5+afrQjoF3pnvlPgf
	+gT8d/0m/vKWr9XcHEdN57Vfj7BKHF1czTajmfmD9z/l3WsXvpY/f1ev2I4lYeYk058bNvR+
	cdQOXWconzknwkfW8er8p1/dhDYetKw2L3g2T2Rm9mx2mUkql7Lfh1/Yu2xj9K9bN78Uen/6
	tjprqc4qpy0lLWk7lViKMxINtZiLihMBvYgbXD4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi~

> > Most of the cpufreq table is sorted in descending order.
> 
> Which part of kernel says that?
> 
-> I couldn't check all. Sorry.

> > But when cpufreq table is made from dev_pm_opp_init_cpufreq_table, it
> > is sorted in ascending order. So in some case to make cpufreq table
> > with descending order it needs an extra work.
> 
> Order of this table shouldn't matter at all in cpufreq layer..
-> You are right. But 5440 cpufreq driver write an index number instead of
clk divider value
for change DVFS. And our another(will submit) also write an index number for
changing DVFS.
As you said, order of table shouldn't matter at all in cpufreq layer. Then,
could this can be applied?
In our case, We want to use index 0 for P0 and index 1 for P1.....

Thanks

Best Ragrds.   



> -----Original Message-----
> From: viresh.linux@gmail.com [mailto:viresh.linux@gmail.com] On Behalf Of
> Viresh Kumar
> Sent: Tuesday, April 29, 2014 2:33 PM
> To: Jonghwan Choi
> Cc: open list; Rafael J. Wysocki; Len Brown
> Subject: Re: [PATCH 1/2] PM / OPP: Use list_for_each_entry_reverse instead
> of list_for_each_entry
> 
> On Tue, Apr 29, 2014 at 10:54 AM, Jonghwan Choi <jhbird.choi@samsung.com>
> wrote:
> > Most of the cpufreq table is sorted in descending order.
> 
> Which part of kernel says that?
> 
> > But when cpufreq table is made from dev_pm_opp_init_cpufreq_table, it
> > is sorted in ascending order. So in some case to make cpufreq table
> > with descending order it needs an extra work.
> 
> Order of this table shouldn't matter at all in cpufreq layer..

