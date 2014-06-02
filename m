Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaFBAfx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 20:35:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40566 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaFBAfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 20:35:51 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-ce-538bc6e5fa1b
Message-id: <538BC6E4.70507@samsung.com>
Date: Mon, 02 Jun 2014 09:35:48 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] extcon: arizona: Update manual headphone detection
 calculation
References: <1401452357-7823-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1401452357-7823-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkRPfpse5gg2OnuCz+TbnBbnF51xw2
	i9uNK9gslr/9z+bA4vFy4m82j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mpo2nSDpeAla8Xh
	XT/ZGxivsnQxcnJICJhITH07hx3CFpO4cG89WxcjF4eQwFJGia39O1m7GDnAinZtSYeIL2KU
	6Lr+kAXCec0osXTNESaQbl4BDYnJT66ATWIRUJXYfHcLK4jNJqAlsf/FDTYQW1QgTGLl9Css
	EPWCEj8m3wOzRQQsJKYsucUMYjMLJErMOfcFbI6wQITEgoYdYDVCAiESj/9uApvJKRAqsfh8
	CxtEvY7E/tZpULa8xOY1b5lBjpMQWMcuserRFkaIgwQkvk0+xALxjazEpgPMEB9LShxccYNl
	AqPYLCQnzUIydhaSsQsYmVcxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525iBEbR6X/P+nYw3jxg
	fYgxGWjlRGYp0eR8YBTmlcQbGpsZWZiamBobmVuakSasJM676GFSkJBAemJJanZqakFqUXxR
	aU5q8SFGJg5OqQbG9Poicfm1NrEPVXZO4n68Wyn9kvOrJQk3VnZP9mqpXLrpxqJU7UWlAfr+
	+tuOeFYZB3OUnV7hW6alcVd/ulRTdeseHr9o7+/5L7fHWNlMM9yyMWDusX33L23x27j1qK7x
	zaMiWhl7uu71rD9x5miTpyVfnl59Vudx39aixb312sI7Qv+9iPmtxFKckWioxVxUnAgA6REe
	nLgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgO7TY93BBsd3MFv8m3KD3eLyrjls
	FrcbV7BZLH/7n82BxePlxN9sHn1bVjF6fN4kF8Ac1cBok5GamJJapJCal5yfkpmXbqvkHRzv
	HG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0TkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Su
	b0gQXI+RARpIWMOY0bTpBkvBS9aKw7t+sjcwXmXpYuTgkBAwkdi1Jb2LkRPIFJO4cG89Wxcj
	F4eQwCJGia7rD1kgnNeMEkvXHGECqeIV0JCY/OQKO4jNIqAqsfnuFlYQm01AS2L/ixtsILao
	QJjEyulXWCDqBSV+TL4HZosIWEhMWXKLGcRmFkiUmHPuC9gcYYEIiQUNO8BqhARCJB7/3QQ2
	k1MgVGLx+RY2iHodif2t06BseYnNa94yT2AUmIVkxSwkZbOQlC1gZF7FKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJERyjz6R2MK5ssDjEKMDBqMTDO2FBV7AQa2JZcWXuIUYJDmYlEd7z87qD
	hXhTEiurUovy44tKc1KLDzEmA0NgIrOUaHI+MH3klcQbGpuYGVkamRtaGBmbkyasJM57oNU6
	UEggPbEkNTs1tSC1CGYLEwenVAMj/2u5BFH+lg9HWkKimd3uBHzVn3Pt2kKf05lpDbMjjKd/
	mS3g3vh+fdnUgoobmi/SSrZ5zI19uvr75JWRHh9U3oadntZ/2tJom06sjfBqjVwWMbMDS/Ku
	/n5S9zTzs0tY+Cat23+r814I2VkvKnv1gLlY/alw3OKYnVUPP8yf3PZuhZ5RTW2LEktxRqKh
	FnNRcSIADKH8WxUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 09:19 PM, Charles Keepax wrote:
> The higher levels of impedance have a higher minimum value than the
> first level. As the same value was used for all levels, higher impedances
> were reported with a very low level of accuracy. This patch applies the
> approriate lower threshold for each level, whilst we are changing things
> add a define for the maximum value at each level to improve readability.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
> 
> Changes since v1:
>  - Added define for range maximum as per review comments
> 
>  drivers/extcon/extcon-arizona.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)

Applied.

Thanks,
Chanwoo Choi

