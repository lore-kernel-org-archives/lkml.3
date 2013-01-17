Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab3AQJ3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:29:23 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:50715 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab3AQJ3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:29:21 -0500
Message-ID: <50F7C3CF.7000507@openwrt.org>
Date: Thu, 17 Jan 2013 10:26:39 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 69/86] drivers/vlynq: remove depends on CONFIG_EXPERIMENTAL
References: <1358391258-1771-1-git-send-email-keescook@chromium.org> <1358391258-1771-70-git-send-email-keescook@chromium.org>
In-Reply-To: <1358391258-1771-70-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 03:54 AM, Kees Cook wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>
> Cc: Florian Fainelli <florian@openwrt.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Florian Fainelli <florian@openwrt.org>
