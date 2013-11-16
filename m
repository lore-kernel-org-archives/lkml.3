Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3KPG1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 01:27:33 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57087 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3KPG13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 01:27:29 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52871050.8060006@roeck-us.net>
Date: Fri, 15 Nov 2013 22:27:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>, linux-omap@vger.kernel.org
CC: linaro-networking@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 02/23] watchdog: omap_wdt: raw read and write endian fix
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org> <1384560086-11994-3-git-send-email-taras.kondratiuk@linaro.org>
In-Reply-To: <1384560086-11994-3-git-send-email-taras.kondratiuk@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 04:01 PM, Taras Kondratiuk wrote:
> From: Victor Kamensky <victor.kamensky@linaro.org>
>
> All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
> Need to use endian neutral functions to read/write h/w registers.
> I.e instead of __raw_read[lw] and __raw_write[lw] functions code
> need to use read[lw]_relaxed and write[lw]_relaxed functions.
> If the first simply reads/writes register, the second will byteswap
> it if host operates in BE mode.
>
> Changes are trivial sed like replacement of __raw_xxx functions
> with xxx_relaxed variant.
>
> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>

Acked-by: Guenter Roeck <linux@roeck-us.net>


