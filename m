Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004Ab3CWMOV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 08:14:21 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4138 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab3CWMOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 08:14:19 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <514D9C8D.20302@broadcom.com>
Date: Sat, 23 Mar 2013 13:14:05 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        "Hante Meuleman" <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmsmac: Remove unused macro SI_MSG
References: <25a69b0ba20a54e5c1c0165e68a1ef2c69c84255.1363982285.git.joe@perches.com>
In-Reply-To: <25a69b0ba20a54e5c1c0165e68a1ef2c69c84255.1363982285.git.joe@perches.com>
X-WSS-ID: 7D5344063A01525873-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 09:00 PM, Joe Perches wrote:
> commit 6236dc2e2 ("brcmsmac: remove some redundant chip common workarounds")
> removed the last uses.

Good riddance.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c | 6 ------
>  1 file changed, 6 deletions(-)


