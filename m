Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaBTCMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 21:12:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41544 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaBTCMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 21:12:37 -0500
X-AuditID: cbfee68e-b7f566d000002344-b1-530564927822
Message-id: <530564A1.50708@samsung.com>
Date: Thu, 20 Feb 2014 11:12:49 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Zhang Yi <yix.x.zhang@gmail.com>, cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add eMMC 5.0 support
References: <1392817677-4755-1-git-send-email-yix.x.zhang@gmail.com>
In-reply-to: <1392817677-4755-1-git-send-email-yix.x.zhang@gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkUHdSCmuwwcI2TYvtrzeyWVzeNYfN
	4sj/fkaLK19bWRxYPHbOusvucejKWkaPz5vkApijuGxSUnMyy1KL9O0SuDIWr/jCWrCbteL9
	4oesDYyTWLoYOTkkBEwkDnW/ZIKwxSQu3FvP1sXIxSEksJRR4vXbrWwwRZMWNrNCJKYzSny6
	8gzKec0ocXrnTKB2Dg5eAQ2JrasjQBpYBFQlJq28zQxiswnoSGz/dhxsg6hAmMTUE1fBNvMK
	CEr8mHwPzBYBWvB2715GEJtZwFri549WVhBbWEBT4sGFb2C2kICLxI9dj8AO4hRwlZiwpIsZ
	ol5dYtK8RVC2vMTmNW+ZQW6TEFjHLrG8+RsbxEECEt8mH2IBuVNCQFZi0wFmiMckJQ6uuMEy
	gVFsFpKTZiEZOwvJ2AWMzKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxAqPo9L9nfTsYbx6w
	PsSYDLRyIrOUaHI+MArzSuINjc2MLExNTI2NzC3NSBNWEudd9DApSEggPbEkNTs1tSC1KL6o
	NCe1+BAjEwenVANjIu+mgwtOHS3sCcpe1/1q85OZmjLWeg7XtzBv8xTbHrLE/umms882CuzR
	uvhKtynaaNbp7REnOv5q3Ws0abDMm17ee/HJzf2XuNVL1vho5e8/IS1T8CzfnrOu+0VD788V
	0rLVNTun3HzXG3jp4583PWEv/jZuvLZfzm1e+IXk+vg4HcfPS46ZKbEUZyQaajEXFScCAFhU
	rQC4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoO6kFNZgg8N/FC22v97IZnF51xw2
	iyP/+xktrnxtZXFg8dg56y67x6Eraxk9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMWLziC2vBbtaK94sfsjYwTmLpYuTkkBAwkZi0sJkVwhaTuHBvPVsXIxeH
	kMB0RolPV56xQjivGSVO75zJ1MXIwcEroCGxdXUESAOLgKrEpJW3mUFsNgEdie3fjjOB2KIC
	YRJTT1wFW8ArICjxY/I9MFsEaNnbvXsZQWxmAWuJnz9awRYLC2hKPLjwDcwWEnCR+LHrERuI
	zSngKjFhSRczRL26xKR5i6BseYnNa94yT2AUmIVkxSwkZbOQlC1gZF7FKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJERyjz6R2MK5ssDjEKMDBqMTDy3GHJViINbGsuDL3EKMEB7OSCG80G2uw
	EG9KYmVValF+fFFpTmrxIcZkYAhMZJYSTc4Hpo+8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtFoH
	CgmkJ5akZqemFqQWwWxh4uCUamCcfCP9/q68k5KuknO0A1azvt2jtEXndMTNnsu6X8Qaf5pV
	s0pt/Dv7QLYe9xb786yKDw1+xk/7auPJEzh/wdKJ165WPVtyk6FOsWrRw8fF9xd63K27U3ay
	ozCjTLN2u11//PxbwbP3/y4u917fvp/j1gVdz0993G3REfuOGPZ8UymJO71R8uIfJZbijERD
	Leai4kQAIwbSWBUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

You can refer to this.

http://comments.gmane.org/gmane.linux.kernel.mmc/23838

Best Regards,
Jaehoon Chung

On 02/19/2014 10:47 PM, Zhang Yi wrote:
> Current code will exist when read eMMC 5.0, add support for it
> 
> Signed-off-by: Zhang Yi <yix.x.zhang@gmail.com>
> ---
>  mmc_cmds.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mmc_cmds.c b/mmc_cmds.c
> index b8afa74..5edf42b 100644
> --- a/mmc_cmds.c
> +++ b/mmc_cmds.c
> @@ -722,6 +722,9 @@ int do_read_extcsd(int nargs, char **argv)
>  	ext_csd_rev = ext_csd[192];
>  
>  	switch (ext_csd_rev) {
> +	case 7:
> +		str = "5.0";
> +		break;
>  	case 6:
>  		str = "4.5";
>  		break;
> 

