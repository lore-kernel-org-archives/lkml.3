Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbaIOWPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:15:08 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44749 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732AbaIOWPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:15:04 -0400
Message-ID: <541764E9.5030308@linaro.org>
Date: Mon, 15 Sep 2014 23:15:05 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] arm: Remove redundant config value DEBUG_UART_NETX
References: <1410818986-13273-1-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1410818986-13273-1-git-send-email-daniel.thompson@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/09/14 23:09, Daniel Thompson wrote:
> Commit 880fa9b6fd73 ("ARM: 8144/1: netx: Migrate DEBUG_LL macros to
> shared directory") spuriously introduces an unused config variable,
> DEBUG_UART_NETX. Let's remove it.

Not sure if this is better shared as a new patch (as below) or respun
from the original (as 8144/2)?
