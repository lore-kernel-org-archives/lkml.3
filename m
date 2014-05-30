Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbaE3Bbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:31:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9577 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbaE3Bbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:31:32 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-d8-5387df724942
Message-id: <5387DF71.2020807@samsung.com>
Date: Fri, 30 May 2014 10:31:29 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] extcon: arizona: Correct typo to disable regulation
 for button detection
References: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1401377274-10249-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1401377274-10249-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkWLfofnuwweODohb/ptxgt7i8aw6b
	xe3GFWwWy9/+Z3Ng8Xg58TebR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGXM3slesIGj4tCL
	PywNjE/Zuhg5OSQETCSe3mhghLDFJC7cWw8U5+IQEljKKLF//hlGmKK7V5ZAJaYzSpw83M4K
	khASeM0o8eSsLYjNK6Al0bjnPthUFgFViVX/74DZbEDx/S9ugNmiAmESK6dfYYGoF5T4Mfke
	mC0iYCExZcktZhCbWSBRYs65L+wgtrBAssTuNY/YIRbPZ5Q4duU92GJOoEEH959ggmjQkdjf
	Oo0NwpaX2LzmLTNIg4TAInaJNR2fmSEuEpD4NvkQ0DYOoISsxKYDzBCfSUocXHGDZQKj2Cwk
	N81CMnYWkrELGJlXMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYgRG0el/z3p3MN4+YH2IMRlo
	5URmKdHkfGAU5pXEGxqbGVmYmpgaG5lbmpEmrCTOm/QwKUhIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QDY//ZBQuPlC5pPzfzV1b7JffX7sce/xRqiu9fIBpycDX7lUUBXwz8X576vWDS/Iun
	dh2YxHtf+LSIx4qXu90F1ks9WDn10d09b6eaP7Y41tU/88kZkWVHC/Z1JXIdZzWN/3bDXT0+
	N/pOye4Nqq/03dy2yn6adqnPJ119fffv3ervum+LHNokOHupEktxRqKhFnNRcSIA/jad+rgC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoG7R/fZggx9z+Cz+TbnBbnF51xw2
	i9uNK9gslr/9z+bA4vFy4m82j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMmL2TvWADR8WhF39YGhifsnUxcnJICJhI3L2yBMoWk7hwbz2QzcUhJDCd
	UeLk4XZWkISQwGtGiSdnbUFsXgEticY998EaWARUJVb9vwNmswHF97+4AWaLCoRJrJx+hQWi
	XlDix+R7YLaIgIXElCW3mEFsZoFEiTnnvrCD2MICyRK71zxih1g8n1Hi2JX3YIs5gQYd3H+C
	CaJBR2J/6zQ2CFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKphYkFxQnpeca6hUn5haX5qXr
	JefnbmIEx+gzqR2MKxssDjEKcDAq8fA2RrYHC7EmlhVX5h5ilOBgVhLhdTwMFOJNSaysSi3K
	jy8qzUktPsSYDAyCicxSosn5wPSRVxJvaGxiZmRpZG5oYWRsTpqwkjjvgVbrQCGB9MSS1OzU
	1ILUIpgtTBycUg2M3ce79etYZe4G2RU2sPq/OXXya2+AhBAX67PDnya2Fs5j1XNxW6Suc/Jn
	rf7DLtubC9dcXutz69bBVf/8zhhLT3GwW83F+dOa7WlHnae1nZPx05vGLxYw/FVZxPqJzfXV
	Lr8IxY+nNiY1WOs8Cq4qWhursWDN04cFbFxnG3iD/yanbP4ntpBPiaU4I9FQi7moOBEAafZ9
	ixUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 12:27 AM, Charles Keepax wrote:
> We can use the bypass mode on the MICVDD reg for button detection, as
> the comment in the code states, however the code was mistakenly
> disabling bypass. This patch corrects this and allows bypass mode during
> button detection.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index c1c8647..b2770aa 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -826,7 +826,7 @@ static void arizona_micd_detect(struct work_struct *work)
>  				ret);
>  
>  		/* Don't need to regulate for button detection */
> -		ret = regulator_allow_bypass(info->micvdd, false);
> +		ret = regulator_allow_bypass(info->micvdd, true);
>  		if (ret != 0) {
>  			dev_err(arizona->dev, "Failed to bypass MICVDD: %d\n",
>  				ret);
> 
Applied.

Thanks,
Chanwoo Choi
