Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934Ab3D3Wdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 18:33:37 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:47428 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686Ab3D3Wdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 18:33:32 -0400
Message-ID: <518046B9.7090604@pobox.com>
Date: Tue, 30 Apr 2013 18:33:29 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>, Alexander Graf <agraf@suse.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] sata_highbank: Rename proc_name to the module name
References: <1367341038-7335-1-git-send-email-rric@kernel.org>
In-Reply-To: <1367341038-7335-1-git-send-email-rric@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2013 12:57 PM, Robert Richter wrote:
> From: Robert Richter <robert.richter@calxeda.com>
>
> mkinitrd looks at /sys/class/scsi_host/host$hostnum/proc_name to find
> the module name of a disk driver. Current name is "highbank-ahci" but
> the module is "sata_highbank". Rename it to match the module name.
>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Alexander Graf <agraf@suse.de>
> Cc: <stable@vger.kernel.org> v3.7..
> Signed-off-by: Robert Richter <robert.richter@calxeda.com>
> ---
>   drivers/ata/sata_highbank.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

applied



