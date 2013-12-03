Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab3LCEJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 23:09:11 -0500
Received: from mail.active-venture.com ([67.228.131.205]:49263 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3LCEJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 23:09:08 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <529D5963.2080607@roeck-us.net>
Date: Mon, 02 Dec 2013 20:09:07 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 35/39] watchdog: remove DEFINE_PCI_DEVICE_TABLE macro
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com> <003801ceefb6$78d25660$6a770320$%han@samsung.com>
In-Reply-To: <003801ceefb6$78d25660$6a770320$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 03:30 PM, Jingoo Han wrote:
> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>


