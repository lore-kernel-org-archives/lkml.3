Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3AYUe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:34:58 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:34115 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3AYUe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:34:56 -0500
Message-ID: <5102EC6E.9000707@pobox.com>
Date: Fri, 25 Jan 2013 15:34:54 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Seth Heasley <seth.heasley@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>
Subject: Re: [PATCH 2/3] ahci: AHCI-mode SATA patch for Intel Avoton DeviceIDs
References: <1359144065-3359-1-git-send-email-seth.heasley@intel.com>
In-Reply-To: <1359144065-3359-1-git-send-email-seth.heasley@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 03:01 PM, Seth Heasley wrote:
> This patch adds the AHCI and RAID-mode SATA DeviceIDs for the Intel Avoton SOC.
>
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> ---
>   drivers/ata/ahci.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)

applied 1-2



