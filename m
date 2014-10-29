Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbaJ2S5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:57:15 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:52649 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbaJ2S5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:57:13 -0400
Message-ID: <545138AD.5090307@gmail.com>
Date: Wed, 29 Oct 2014 11:57:49 -0700
From: Santosh Shilimkar <santosh.shilimkar@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
CC: Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <ssantosh@kernel.org>
Subject: Re: [PATCH v1 1/4] ARM: keystone: add pcie related options
References: <1414601134-31825-1-git-send-email-m-karicheri2@ti.com> <1414601134-31825-2-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1414601134-31825-2-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 09:45 AM, Murali Karicheri wrote:
> Now that Keystone PCI controller is merged, add pcie related options
> by default for keystone architecture so that driver can be enabled in
> the build.
>
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Santosh Shilimkar <ssantosh@kernel.org>
> ---
>   - v1 - No change w.r.t
>   arch/arm/mach-keystone/Kconfig |    2 ++
>   1 file changed, 2 insertions(+)
>
Looks good. Will pick this up for next merge window.

Regards,
Santosh
