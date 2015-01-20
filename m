Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbbATGMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 01:12:48 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20120 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbbATGMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 01:12:46 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-e1-54bdf1db0a62
Message-id: <54BDF1DA.6070507@samsung.com>
Date: Tue, 20 Jan 2015 07:12:42 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: balbi@ti.com, paulz@synopsys.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] usb: dwc2: fix the uncompleted requests problem
References: <1420450295-25818-1-git-send-email-r.baldyga@samsung.com>
In-reply-to: <1420450295-25818-1-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t/xa7q3P+4NMfjVo2Fx8H69RfPi9WwW
	l3fNYbNYtKyV2WL7lOlMDqwe++euYffYsv8zo8fxG9uZPD5vkgtgieKySUnNySxLLdK3S+DK
	+LR5B2vBKfaKw983szUwtrN1MXJySAiYSOzcOgfKFpO4cG89kM3FISSwlFFiWuMyRpCEkMBH
	Rom7H6NBbF4BLYmZ/V2sIDaLgKrEjF2PwZrZBHQktnyfAFYvKhAh8WHVVzaIekGJH5PvsYDY
	IgIqEhefTweyOTiYBSIltjSIgpjCAh4SX5sNQUwhAVeJlQvDQIo5BdwkLlydzw5RrCdx/6IW
	SJhZQF5i85q3zBMYBWYhGT8LoWoWkqoFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUJC
	98sOxsXHrA4xCnAwKvHwauTsCRFiTSwrrsw9xCjBwawkwjvh6d4QId6UxMqq1KL8+KLSnNTi
	Q4xMHJxSDYzLdW1XR2+f3ONr8vN65ialR3NjQ+/+0g46X3u75426t9XDa1tj3x56XST4Iknp
	74ttxka7Ov9+KfcXeGRbcKfg6M4P6ul6s8s/fqm0WFbJO31t4MFbARbsPlECjz5uPcGaV/vJ
	8dQuu+nvFCIvCNxfmqfotoP75809dzQWLn+navdlzjXF1u69SizFGYmGWsxFxYkABcpkJzsC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

I can't see these patches in your tree. I see only "usb: dwc2: gadget:
kill requests with 'force' in s3c_hsotg_udc_stop()", which doesn't fix
the bug completely. I was sure that my the final patch was in your tree,
so what happened? Can you apply these patches to fix this problem?

On 01/05/2015 10:31 AM, Robert Baldyga wrote:
> Hi Felipe,
> 
> I prepared this patchset in response to our discussion:
> https://lkml.org/lkml/2014/12/29/193
> 
> It reverts of unproper patch and adds working solution of the problem
> described in commit messages.
> 
> Best regards,
> Robert Baldyga
> 
> Robert Baldyga (2):
>   Revert "usb: dwc2: gadget: kill requests with 'force' in
>     s3c_hsotg_udc_stop()"
>   drivers: usb: dwc2: remove 'force' parameter from kill_all_requests()
> 
>  drivers/usb/dwc2/gadget.c | 31 ++++++++++---------------------
>  1 file changed, 10 insertions(+), 21 deletions(-)
> 

Best regards,
Robert Baldyga
