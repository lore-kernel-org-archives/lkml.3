Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198Ab3L3F7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 00:59:38 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:61704 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3L3F7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 00:59:37 -0500
Message-ID: <52C10BCC.2030907@linaro.org>
Date: Sun, 29 Dec 2013 23:59:40 -0600
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: mike.turquette@linaro.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: support hardware-specific debugfs entries
References: <1388383130-8029-1-git-send-email-elder@linaro.org>
In-Reply-To: <1388383130-8029-1-git-send-email-elder@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2013 11:58 PM, Alex Elder wrote:
> Add a new clk_ops->debug_init method to allow a clock hardware
> driver to populate the clock's debugfs directory with entries
> beyond those common for every clock.

Sorry, forgot to indicate "v2" in the Subject line...	-Alex

> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> v2: - Define debug_init unconditionally (suggested by Gerhard Sittig).

