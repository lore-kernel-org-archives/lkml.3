Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbaGWJSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:18:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24724 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757395AbaGWJSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:18:12 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-ce-53cf7dd234e8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kiran Padwal'" <kiran.padwal21@gmail.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        kiran.padwal@smartplayin.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1406101102-11894-1-git-send-email-kiran.padwal@smartplayin.com>
In-reply-to: <1406101102-11894-1-git-send-email-kiran.padwal@smartplayin.com>
Subject: Re: [PATCH] usb: phy: msm: Make of_device_id array const
Date: Wed, 23 Jul 2014 18:18:10 +0900
Message-id: <001901cfa657$05d4a020$117de060$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+mSi7MEUI+cq+NRRWxfCaVvCx47AADJATw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zfd1LteeDDRq2WFgcvF9v0bx4PZvF
	5YWXWC2uzbjJbnHw+1kWi4n7z7JbXN41h81i0bJWZgcOj52z7rJ77J+7ht2jb8sqRo85Hxax
	eBy/sZ3J4/MmuQC2KC6blNSczLLUIn27BK6MiZ13mAtOsldc3niMqYFxIlsXIyeHhICJxPSn
	R5ghbDGJC/fWA8W5OIQEljFKrJ46mQmm6NmyU0wQiUWMEnO7dzBDOL8ZJQ6+egVWxSagJvHl
	y2F2EFtEQFfi7LLXLCBFzAKnGCVeTbvOCJIQEvCRWNL6AqyIU8BX4un8BWB3CAs4Snx8uA6o
	hoODRUBV4vuDYJAwr4CtxL/H+5khbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywzSKiGgLvHo
	ry7ECUYSRyZdYIYoEZHY9+IdI8g5EgJ/2SXu7DoN1ssiICDxbfIhFoheWYlNB6AhISlxcMUN
	lgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZIRPfuYLx9
	wPoQYzLQ+onMUqLJ+cCEkFcSb2hsZmRhamJqbGRuaUaasJI4b9LDpCAhgfTEktTs1NSC1KL4
	otKc1OJDjEwcnFINjJvW2kffDithFa6wmndduNS6qyiesyU0xejtuXfzjyzirDea8yRSJkM2
	Q/ZwYdMB5vZlmzrXeDiLJ7SldgWYrtslWf35jcPz4PPW1htOzT60Y3WO7DxL/WsCO6pV/r9z
	Xpwl57Lt51n7iZJuwpNzOQrZ1VTV4vVKznCpFL2OMbV75sM05Su7EktxRqKhFnNRcSIAgL9U
	rv4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jAd1LteeDDSbONbE4eL/eonnxejaL
	ywsvsVpcm3GT3eLg97MsFhP3n2W3uLxrDpvFomWtzA4cHjtn3WX32D93DbtH35ZVjB5zPixi
	8Th+YzuTx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2
	Si4+AbpumTlABykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMyZ23mEu
	OMlecXnjMaYGxolsXYycHBICJhLPlp1igrDFJC7cWw8U5+IQEljEKDG3ewczhPObUeLgq1dg
	VWwCahJfvhxmB7FFBHQlzi57zQJSxCxwilHi1bTrjCAJIQEfiSWtL8CKOAV8JZ7OXwC2TljA
	UeLjw3VANRwcLAKqEt8fBIOEeQVsJf493s8MYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aQ
	VgkBdYlHf3UhTjCSODLpAjNEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk
	9FwjveLE3OLSvHS95PzcTYzgdPFMegfjqgaLQ4wCHIxKPLwFNeeChVgTy4orcw8xSnAwK4nw
	OpefDxbiTUmsrEotyo8vKs1JLT7EaAr050RmKdHkfGAqyyuJNzQ2MTOyNDKzMDIxN1cS5z3Y
	ah0oJJCeWJKanZpakFoE08fEwSnVwDilj1t7taOxmNGC4PndT5Wm/+D/fSpn5oYlDIeKPF9/
	viWicveDeG7c0hu3s7xOnWJi+3omUWeysOKL4E3B4ZsuFXytmu79qSqaU1w59MH6ZQ6l5R+V
	qlgs//Ud2PuTo+Nq58+wVetYJSuaz0u6zWFY5zX3xIuXf5XWrPuywHOi+jb2rrs8dx4psRRn
	JBpqMRcVJwIAAtsNSC0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 23, 2014 4:38 PM, Kiran Padwal wrote:
> 
> Make of_device_id array const, because all OF functions handle it as const.

Hi Kiran Padwal,

The same patch was already submitted and merged to USB tree.
Thank you.

Best regards,
Jingoo Han

> 
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
> ---
>  drivers/usb/phy/phy-msm-usb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> index 78cc870..e4108ee 100644
> --- a/drivers/usb/phy/phy-msm-usb.c
> +++ b/drivers/usb/phy/phy-msm-usb.c
> @@ -1429,7 +1429,7 @@ static void msm_otg_debugfs_cleanup(void)
>  	debugfs_remove(msm_otg_dbg_root);
>  }
> 
> -static struct of_device_id msm_otg_dt_match[] = {
> +static const struct of_device_id msm_otg_dt_match[] = {
>  	{
>  		.compatible = "qcom,usb-otg-ci",
>  		.data = (void *) CI_45NM_INTEGRATED_PHY
> --
> 1.7.9.5

