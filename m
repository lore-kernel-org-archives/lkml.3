Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaFMOiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:38:11 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:51048 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaFMOiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:38:09 -0400
Message-ID: <539B0CCD.9060509@mm-sol.com>
Date: Fri, 13 Jun 2014 17:38:05 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ata: Add Qualcomm ARM SoC AHCI SATA host controller
 driver
References: <1402600404-19214-1-git-send-email-galak@codeaurora.org> <1402600404-19214-2-git-send-email-galak@codeaurora.org>
In-Reply-To: <1402600404-19214-2-git-send-email-galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

> +
> +static struct platform_driver qcom_ahci_driver = {
> +	.probe = qcom_ahci_probe,
> +	.remove = ata_platform_remove_one,
> +	.driver = {
> +		.name = "qcom_ahci_qcom",
> +		.owner = THIS_MODULE,
> +		.of_match_table = qcom_ahci_of_match,
> +	},
> +};
> +module_platform_driver(qcom_ahci_driver);
> +
> +MODULE_DESCRIPTION("Qualcomm AHCI SATA platform driver");
> +MODULE_LICENSE("GPL");

"GPL v2" ? Or only GPL is intentional?

> +MODULE_ALIAS("ahci:qcom");
> 

missing MODULE_AUTHOR

-- 
regards,
Stan
