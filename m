Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3JKVxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:53:46 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39226 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3JKVxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 17:53:44 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        Alexander Shiyan <shc_work@mail.ru>
Subject: Re: [PATCH 1/2] ARM: clps711x: Use linux/sched_clock.h
References: <1380829783-876-1-git-send-email-sboyd@codeaurora.org>
Date: Fri, 11 Oct 2013 14:53:41 -0700
In-Reply-To: <1380829783-876-1-git-send-email-sboyd@codeaurora.org> (Stephen
	Boyd's message of "Thu, 3 Oct 2013 12:49:42 -0700")
Message-ID: <87bo2v8oey.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Stephen Boyd <sboyd@codeaurora.org> writes:

> The sched_clock.h include is under include/linux now.
>
> Cc: Alexander Shiyan <shc_work@mail.ru>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

I applied both of these to next/cleanup.

Thanks,

Kevin
