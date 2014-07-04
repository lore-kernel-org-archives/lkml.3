Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaGDCkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 22:40:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23725 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaGDCkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 22:40:06 -0400
X-AuditID: cbfee68f-b7fef6d000003970-81-53b614033a9f
Message-id: <53B61403.7040602@samsung.com>
Date: Fri, 04 Jul 2014 11:40:03 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>, chris@printf.net,
        ulf.hansson@linaro.org, tgih.jun@samsung.com, aaron.lu@intel.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jackey.shen@amd.com, gregkh@linuxfoundation.org
Subject: Re: One bug of SDHCI driver
References: <53B249A4.2040404@linux.intel.com>
 <53B57B23.4020607@linux.intel.com>
In-reply-to: <53B57B23.4020607@linux.intel.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkRJdZZFuwwdEHuhab+n6zWUy4vJ3R
	onnxeiDr3kRWi8u75rBZHPnfz2jx4f5FZovja8Mt2i9dZHbg9Gi99JfNY/Gel0wed67tYfOY
	dzLQY//cNeweN14tZPLo27KK0ePzJrkAjigum5TUnMyy1CJ9uwSujOYJW5gKTrNWbFzxjKmB
	cRtLFyMnh4SAiUTToRlQtpjEhXvr2boYuTiEBJYyStw7vBSu6P3nT4wQiUWMEk/O/2aFcF4z
	SnxvbmMGqeIV0JK4duwRG4jNIqAqMb1vMlg3m4COxPZvx5lAbFGBMIlDbfOYIOoFJX5MvscC
	MkhE4AujxOlHjUBTOTiEBVQk5r7lB6kREgiWuLnuIyuIzSmgL/HwzE9GEJsZaOb+1mlsELa8
	xOY1b5lB5kgIPGKXWPDwNSvEEQIS3yYfYgGZKSEgK7HpADPEN5ISB1fcYJnAKDoLyRmzkIyd
	hWTsAkbmVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiB8Xj637P+HYx3D1gfYkwGWjmRWUo0
	OR8Yz3kl8YbGZkYWpiamxkbmlmakCSuJ895/mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1Oq
	gTHy8lwNvgjfW0Y5R3RuLAy5cklAUrlhXh4j06vpSaGNx/V4+2a8fDPXISpC7fO5NfO82bpm
	JLUuuG5j2nnxo+Cdk6/SqiNaRRY/Zpl7sC1tX3lmiWPS/U8qu7l5LkWt9ptop+jRJLjmtPT9
	KXcCfzA3Hyr5WP++6Lb3FPlecZmuix7JLt0/1JVYijMSDbWYi4oTAS0sjgPdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jAV1mkW3BBn0HVC029f1ms5hweTuj
	RfPi9UDWvYmsFpd3zWGzOPK/n9Hiw/2LzBbH14ZbtF+6yOzA6dF66S+bx+I9L5k87lzbw+Yx
	72Sgx/65a9g9brxayOTRt2UVo8fnTXIBHFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYG
	hrqGlhbmSgp5ibmptkouPgG6bpk5QOcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLr
	MTJAAwlrGDOaJ2xhKjjNWrFxxTOmBsZtLF2MnBwSAiYS7z9/YoSwxSQu3FvP1sXIxSEksIhR
	4sn536wQzmtGie/NbcwgVbwCWhLXjj1iA7FZBFQlpvdNBpvEJqAjsf3bcSYQW1QgTOJQ2zwm
	iHpBiR+T77GADBIR+MIocfpRI9BUDg5hARWJuW/5QWqEBIIlbq77yApicwroSzw88xPsImag
	mftbp7FB2PISm9e8ZZ7AyD8LydhZSMpmISlbwMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93
	EyM42p9J7WBc2WBxiFGAg1GJh9ejaGuwEGtiWXFl7iFGCQ5mJRHeALZtwUK8KYmVValF+fFF
	pTmpxYcYTYG+nsgsJZqcD0xEeSXxhsYmZkaWRuaGFkbG5krivAdarQOFBNITS1KzU1MLUotg
	+pg4OKUaGFNaBQS0Mjp2BEh/0dTWrbBfFv51ol5+q+yao/YzjAKf8JxTu1zxcbM8I0upSFmu
	6kXelSca/15V+h7Y3v/OZv91dX27c+WMSqc12sK2PbFuj//KPiHoRNdzp7yYYz+2r7BMnJRm
	krfxtF1xwhyO+NjbG1OEtXg4E03eLZT285xZ7rukSTVMiaU4I9FQi7moOBEAVJv1WQwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just use the MMC_CAP2_SDIO_IRQ_NOTHREAD?

if (!err && host->sdio_irq && !(host->quirks & MMC_CAP2_SDIO_IRQ_NOTHREAD))
	wake_up_process(host->sdio_irq_thread);

I didn't test this..but i believe that it will be fixed.

Best Regards,
Jaehoon Chung

On 07/04/2014 12:47 AM, Fu, Zhonghui wrote:
> 
> Hi, all
> 
> The statement "mmc->caps2 |= MMC_CAP2_SDIO_IRQ_NOTHREAD;" is added in "sdhci_add_host" function in host/sdhci.c file. In some cases, this will make  "host->sdio_irq_thread" a NULL pointer in "mmc_sdio_resume" functon of core/sdio.c file and lead to resume failure. Could you please give me some advice how to fix this bug?
> 
> 
> 
> Thanks,
> Zhonghui
> 
> 
> 
> 
> 
> 

