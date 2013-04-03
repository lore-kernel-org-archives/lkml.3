Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861Ab3DCX4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 19:56:18 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:45328 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762128Ab3DCX4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 19:56:16 -0400
Message-ID: <515CC19E.40906@pobox.com>
Date: Wed, 03 Apr 2013 19:56:14 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: ata: Use resource_size function
References: <1363444332-379-1-git-send-email-gheorghiuandru@gmail.com>
In-Reply-To: <1363444332-379-1-git-send-email-gheorghiuandru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2013 10:32 AM, Alexandru Gheorghiu wrote:
> Use resource_size function instead of explicit computation.
> Patch found using coccinelle.
>
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>   drivers/ata/pata_octeon_cf.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

applied



