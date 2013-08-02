Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab3HBX6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:58:48 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59228 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab3HBX6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:58:47 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <51FC47B5.5050103@roeck-us.net>
Date: Fri, 02 Aug 2013 16:58:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jonas Jensen <jonas.jensen@gmail.com>
CC: linux-watchdog@vger.kernel.org, wim@iguana.be,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, arnd@arndb.de
Subject: Re: [PATCH v8] watchdog: Add MOXA ART watchdog driver
References: <1375101228-10930-1-git-send-email-jonas.jensen@gmail.com> <1375454445-15589-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1375454445-15589-1-git-send-email-jonas.jensen@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 07:40 AM, Jonas Jensen wrote:
> This patch adds a watchdog driver for the main hardware watchdog timer
> found on MOXA ART SoCs.
>
> The MOXA ART SoC provides one writable timer register, restarting
> the hardware once it reaches zero. The register is auto decremented
> every APB clock cycle.
>
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Still wondering where the requirement comes from not to use unlikely()
in probe functions. Must be one of those tribal knowledge things people
have been talking about.

Nevertheless, still

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter

