Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317Ab3D3Q7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:59:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759576Ab3D3Q7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:59:16 -0400
Message-ID: <517FF861.2090308@suse.de>
Date: Tue, 30 Apr 2013 18:59:13 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120306 Thunderbird/10.0.3
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>, stable@vger.kernel.org
Subject: Re: [PATCH] sata_highbank: Rename proc_name to the module name
References: <1367341038-7335-1-git-send-email-rric@kernel.org>
In-Reply-To: <1367341038-7335-1-git-send-email-rric@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2013 06:57 PM, Robert Richter wrote:
> From: Robert Richter<robert.richter@calxeda.com>
>
> mkinitrd looks at /sys/class/scsi_host/host$hostnum/proc_name to find
> the module name of a disk driver. Current name is "highbank-ahci" but
> the module is "sata_highbank". Rename it to match the module name.
>
> Cc: Rob Herring<rob.herring@calxeda.com>
> Cc: Alexander Graf<agraf@suse.de>
> Cc:<stable@vger.kernel.org>  v3.7..
> Signed-off-by: Robert Richter<robert.richter@calxeda.com>

Acked-by: Alexander Graf <agraf@suse.de>


Alex

> ---
>   drivers/ata/sata_highbank.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
> index 5dba77c..b1a664a 100644
> --- a/drivers/ata/sata_highbank.c
> +++ b/drivers/ata/sata_highbank.c
> @@ -251,7 +251,7 @@ static const struct ata_port_info ahci_highbank_port_info = {
>   };
>
>   static struct scsi_host_template ahci_highbank_platform_sht = {
> -	AHCI_SHT("highbank-ahci"),
> +	AHCI_SHT("sata_highbank"),
>   };
>
>   static const struct of_device_id ahci_of_match[] = {

