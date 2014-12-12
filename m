Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031117AbaLLR0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:26:06 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:37702 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031073AbaLLR0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:26:01 -0500
Message-ID: <548B2524.9050806@cogentembedded.com>
Date: Fri, 12 Dec 2014 20:25:56 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v1] libata: export ata_get_cmd_descript()
References: <1418397391-13668-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1418397391-13668-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/12/2014 06:16 PM, Andy Shevchenko wrote:

> The driver sata_dwc_460ex is using this symbol. To build it as a module we have
> to have the symbol exported. This patch adds EXPORT_SYMBOL() macro for that.

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>   drivers/ata/libata-eh.c | 1 +
>   1 file changed, 1 insertion(+)

> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index 3dbec89..74fef87 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -2389,6 +2389,7 @@ const char *ata_get_cmd_descript(u8 command)
>
>   	return NULL;
>   }
> +EXPORT_SYMBOL(ata_get_cmd_descript);

    Why not EXPORT_SYMBOL_GPL()?

MBR, Sergei

