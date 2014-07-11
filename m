Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaGKJtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:49:22 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:63491 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaGKJtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:49:20 -0400
Message-ID: <53BFB2D4.80004@gmail.com>
Date: Fri, 11 Jul 2014 15:18:04 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: varkabhadram@gmail.com, netdev@vger.kernel.org
CC: Thomas.Lendacky@amd.com, geert+renesas@linux-m68k.org,
        ebiederm@xmission.com, macro@linux-mips.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 0/8] cleanup for AMD811E ethernet driver
References: <1405064110-22579-1-git-send-email-varkabhadram@gmail.com>
In-Reply-To: <1405064110-22579-1-git-send-email-varkabhadram@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 07/11/2014 01:05 PM, varkabhadram@gmail.com wrote:
> From: Varka Bhadram <varkab@cdac.in>
>
> This series cleanup for AMD811E ethernet driver
>
> Varka Bhadram (8):
>    ethernet: amd: move amd111e_remove_one after probe
>    ethernet: amd: use devm_ioremap()
>    ethernet: amd: dynamic debug fixes
>    ethernet: amd: fix comment styles
>    ethernet: amd: move pci device ids
>    ethernet: amd: fix 'foo* bar'
>    ethernet: amd: fix spaces and few coding styles
>    ethernet: amd: switch case fixes
>
>   drivers/net/ethernet/amd/amd8111e.c |  993 +++++++++++++++++------------------
>   1 file changed, 484 insertions(+), 509 deletions(-)
>
Please drop this series. I am getting checkpatch.pl errors.

I will fix it send it as 'v2'.
-- 
Regards,
Varka Bhadram.

