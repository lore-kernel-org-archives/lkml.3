Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab3F1JYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:24:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27478 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab3F1JYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:24:15 -0400
X-AuditID: cbfee691-b7fef6d000002d62-7f-51cd563e2f7d
Message-id: <51CD563D.9010809@samsung.com>
Date: Fri, 28 Jun 2013 18:24:13 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Subject: Re: [PATCH v4] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
References: <1372405697-13556-1-git-send-email-cw00.choi@samsung.com>
 <CAKohpomk7tC4xZ32sOh4NQR-qNOM=xHj43GcMu_squ1nFELGpg@mail.gmail.com>
In-reply-to: <CAKohpomk7tC4xZ32sOh4NQR-qNOM=xHj43GcMu_squ1nFELGpg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRsSkWNcu7GygwaWt/BZPm36wW5xtesNu
	cXnXHDaLz71HGC1uN65gs+hf2MtksfGrhwO7x51re9g8+rasYvR4tLiF0ePzJrkAligum5TU
	nMyy1CJ9uwSujAs3XjIWXGCp2HLxC3sD4ynmLkZODgkBE4ltDbMYIWwxiQv31rN1MXJxCAks
	ZZTYv/kdI0zRloZZUIlFjBK/du1gh3BeMErcvnQMKMPBwSugJfH3UAVIA4uAqsSOZ4dZQGw2
	oPD+FzfYQGxRgTCJldOvgMV5BQQlfky+xwLSKgJU8/JmKshIZoHpjBLTf+wCu05YIEPi+vEP
	UIt7GCU+v77DBJLgFAiWWHriD1gRs4COxP7WaWwQtrzE5jVvmUEaJASOsUts7lrHDHGRgMS3
	yYfAtkkIyEpsOgD1vqTEwRU3WCYwis1CctMsJGNnIRm7gJF5FaNoakFyQXFSepGpXnFibnFp
	Xrpecn7uJkZgtJ3+92ziDsb7B6wPMSYDrZzILCWanA+M1rySeENjMyMLUxNTYyNzSzPShJXE
	edVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MGZ98fuiyag149X/WS/mx8usODef+4Nu
	mPzPLfOO96avuOJ991bJXvYepSSrk3fvqG2Uea534HNTQQ8zs8zqPJuZYk+SzO6ZKE5Vv7Y7
	/e2PW9HvfgY+P2DqVN7oUdP7uu/cvI933dpsrjMaZD/XNU1K/8X2l+FjjViE0E7bL/eFmspz
	T71580uJpTgj0VCLuag4EQDiUba9zAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAV27sLOBBvNucVg8bfrBbnG26Q27
	xeVdc9gsPvceYbS43biCzaJ/YS+TxcavHg7sHneu7WHz6NuyitHj0eIWRo/Pm+QCWKIaGG0y
	UhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgC5QUihLzCkF
	CgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGZcuPGSseACS8WWi1/YGxhPMXcxcnJI
	CJhIbGmYxQZhi0lcuLceyObiEBJYxCjxa9cOdgjnBaPE7UvHgDIcHLwCWhJ/D1WANLAIqErs
	eHaYBcRmAwrvf3EDbJCoQJjEyulXwOK8AoISPybfYwFpFQGqeXkzFWQks8B0RonpP3aBHSEs
	kCFx/fgHqMU9jBKfX99hAklwCgRLLD3xB6yIWUBHYn/rNDYIW15i85q3zBMYBWYh2TELSdks
	JGULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTH8jPpHYyrGiwOMQpwMCrx8DYkngkU
	Yk0sK67MPcQowcGsJMJ7ZwFQiDclsbIqtSg/vqg0J7X4EGMyMAgmMkuJJucD00xeSbyhsYmZ
	kaWRuaGFkbE5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTDKLlLdaqV+921j0DlrYVP1
	nLx41/b497O2n11xj/FJyM+tNa4Pn/bd/PP6yK+nzDMYDugVCyzs3lbztnvGFg12hbe5zH8e
	XHvmfe0V62TXN8u5npd3maw8+Eksw/PYihz5v/JOMgUMd1+t8g+JlLp9PYj9aefRDQZpEczd
	sxwrft/fUc//UWeyEktxRqKhFnNRcSIAozjb5CkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 05:27 PM, Viresh Kumar wrote:
> On 28 June 2013 13:18, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>  drivers/cpufreq/Kconfig            |   6 +
>>  drivers/cpufreq/cpufreq.c          |   4 +
>>  drivers/cpufreq/cpufreq_governor.c |  15 +++
>>  drivers/cpufreq/cpufreq_stats.c    | 241 +++++++++++++++++++++++++++++++++----
>>  include/linux/cpufreq.h            |   6 +
>>  5 files changed, 246 insertions(+), 26 deletions(-)
> 
> Please update Documentation/cpu-freq/cpufreq-stats.txt for this as well.

OK. I'll add description.

Best Regards,
Chanwoo Choi

