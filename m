Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaA3Gzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 01:55:43 -0500
Received: from nbd.name ([46.4.11.11]:43962 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaA3Gzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 01:55:41 -0500
Message-ID: <52E9F757.3040306@openwrt.org>
Date: Thu, 30 Jan 2014 07:55:19 +0100
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix uninitialized variable in ath9k_has_tx_pending()
References: <1390733601-11244-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1390733601-11244-1-git-send-email-geert@linux-m68k.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-26 11:53, Geert Uytterhoeven wrote:
> drivers/net/wireless/ath/ath9k/main.c: In function ‘ath9k_has_tx_pending’:
> drivers/net/wireless/ath/ath9k/main.c:1869: warning: ‘npend’ may be used uninitialized in this function
> 
> Introduced by commit 10e2318103f5941aa70c318afe34bc41f1b98529 ("ath9k:
> optimize ath9k_flush").
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Felix Fietkau <nbd@openwrt.org>
