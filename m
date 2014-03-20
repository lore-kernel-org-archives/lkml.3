Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbaCTR2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:28:40 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:48031 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbaCTR2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:28:38 -0400
Message-ID: <532B2540.8050601@fastmail.fm>
Date: Thu, 20 Mar 2014 18:28:32 +0100
From: Bernd Schubert <bernd.schubert@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>, jejb@kernel.org,
        JBottomley@Parallels.com
CC: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com,
        Nagalakshmi.Nandigama@lsi.com, linux-kernel@vger.kernel.org,
        sreekanthreddy0547@gmail.com
Subject: Re: [PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter
 disable_eedp to Disable EEDP Support
References: <20140314153622.GA7947@lsi.com>
In-Reply-To: <20140314153622.GA7947@lsi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: UTF-8
X-ITWM-Scanned-By: mail1.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   	u8		scsi_io_cb_idx;
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index 7f0af4f..d502728 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -127,6 +127,11 @@ static int disable_discovery = -1;
>   module_param(disable_discovery, int, 0);
>   MODULE_PARM_DESC(disable_discovery, " disable discovery ");
>
> +/* Enable or disable EEDP support */
> +static int disable_eedp;
> +module_param(disable_eedp, uint, 0);
> +MODULE_PARM_DESC(disable_eedp, " disable EEDP support: (default=0)");

Wouldn't it make sense to exlain what EEDP means? Something like

MODULE_PARM_DESC(disable_eedp,
		" disable end-to-end data protection support (DIF): "
		"default=0)");



