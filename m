Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaGVOx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:53:56 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33103 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbaGVOxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:53:53 -0400
Date: Tue, 22 Jul 2014 15:53:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Kiran Padwal <kiran.padwal21@gmail.com>
Cc: tj@kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ahci: st: Make of_device_id array const
Message-ID: <20140722145347.GA23210@lee--X1>
References: <1406038543-26545-1-git-send-email-kiran.padwal21@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406038543-26545-1-git-send-email-kiran.padwal21@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Kiran Padwal wrote:
> Make of_device_id array const, because all OF functions handle it as const.
> 
> Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>
> ---
>  drivers/ata/ahci_st.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
