Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3KQTJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 14:09:15 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:42095 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751360Ab3KQTJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 14:09:07 -0500
Date: Sun, 17 Nov 2013 20:09:05 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: linux-omap@vger.kernel.org, linaro-networking@linaro.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 02/23] watchdog: omap_wdt: raw read and write endian fix
Message-ID: <20131117190905.GI10136@spo001.leaseweb.com>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org> <1384560086-11994-3-git-send-email-taras.kondratiuk@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384560086-11994-3-git-send-email-taras.kondratiuk@linaro.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Victor, Taras,

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

This was added to linux-watchdog-next.

Kind regards,
Wim.

