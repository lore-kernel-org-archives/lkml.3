Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab3LDHPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 02:15:10 -0500
Received: from mail.active-venture.com ([67.228.131.205]:61378 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3LDHPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 02:15:09 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <529ED678.1080401@roeck-us.net>
Date: Tue, 03 Dec 2013 23:15:04 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Christophe Leroy <christophe.leroy@c-s.fr>,
        Wim Van Sebroeck <wim@iguana.be>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3] watchdog: mpc8xxx_wdt convert to watchdog core
References: <20131204063214.D1DB01A2BEA@localhost.localdomain>
In-Reply-To: <20131204063214.D1DB01A2BEA@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 10:32 PM, Christophe Leroy wrote:
> Convert mpc8xxx_wdt.c to the new watchdog API.
>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

