Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaBIUJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:09:08 -0500
Received: from mail.active-venture.com ([67.228.131.205]:54792 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaBIUJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:09:06 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52F7E062.9060102@roeck-us.net>
Date: Sun, 09 Feb 2014 12:09:06 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu
CC: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/10] watchdog: xilinx: Move no_timeout to probe function
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <8273bfbdf42dcd94f4e05a543de19b200f192e66.1391177880.git.michal.simek@xilinx.com>
In-Reply-To: <8273bfbdf42dcd94f4e05a543de19b200f192e66.1391177880.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 06:18 AM, Michal Simek wrote:
> no_timeout should be local variable because it is used
> only in probe function.
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>


