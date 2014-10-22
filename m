Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaJVSsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:48:15 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:64550 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaJVSsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:48:13 -0400
Message-ID: <5447FBF4.8020702@gmail.com>
Date: Wed, 22 Oct 2014 11:48:20 -0700
From: Santosh Shilimkar <santosh.shilimkar@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
CC: linux-pm@vger.kernel.org, Santosh Shilimkar <ssantosh@kernel.org>
Subject: Re: [PATCH v2 02/47] memory: emif: Use API function to determine
 poweroff capability
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net> <1413864783-3271-3-git-send-email-linux@roeck-us.net>
In-Reply-To: <1413864783-3271-3-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/20/2014 09:12 PM, Guenter Roeck wrote:
> Use have_kernel_power_off() to determine if the kernel is able
> to power off the system.
>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2:
> - poweroff -> power_off
>
Acked-by: Santosh Shilimkar <ssantosh@kernel.org>

