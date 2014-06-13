Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaFMQLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:11:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34211 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaFMQL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:11:29 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH 2/3] ata: Add Qualcomm ARM SoC AHCI SATA host controller driver
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <539B0CCD.9060509@mm-sol.com>
Date: Fri, 13 Jun 2014 11:11:23 -0500
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <CB5F4E2D-7FD3-4597-AE5F-97AB47247B25@codeaurora.org>
References: <1402600404-19214-1-git-send-email-galak@codeaurora.org> <1402600404-19214-2-git-send-email-galak@codeaurora.org> <539B0CCD.9060509@mm-sol.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 13, 2014, at 9:38 AM, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:

> Hi Kumar,
> 
>> +
>> +static struct platform_driver qcom_ahci_driver = {
>> +	.probe = qcom_ahci_probe,
>> +	.remove = ata_platform_remove_one,
>> +	.driver = {
>> +		.name = "qcom_ahci_qcom",
>> +		.owner = THIS_MODULE,
>> +		.of_match_table = qcom_ahci_of_match,
>> +	},
>> +};
>> +module_platform_driver(qcom_ahci_driver);
>> +
>> +MODULE_DESCRIPTION("Qualcomm AHCI SATA platform driver");
>> +MODULE_LICENSE("GPL");
> 
> "GPL v2" ? Or only GPL is intentional?

should be v2, will fix

> 
>> +MODULE_ALIAS("ahci:qcom");
>> 
> 
> missing MODULE_AUTHOR
> 
> -- 
> regards,
> Stan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

