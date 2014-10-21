Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207AbaJUQzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:55:43 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:49409 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbaJUQzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:55:41 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: <broonie@kernel.org>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nicolas.ferre@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] spi/atmel: improve the system suspend/resume functions implementation
References: <1413863014-1791-1-git-send-email-wenyou.yang@atmel.com>
Date: Tue, 21 Oct 2014 09:55:37 -0700
In-Reply-To: <1413863014-1791-1-git-send-email-wenyou.yang@atmel.com> (Wenyou
	Yang's message of "Tue, 21 Oct 2014 11:43:34 +0800")
Message-ID: <7hlho9cqgm.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wenyou Yang <wenyou.yang@atmel.com> writes:

> To make it cleaner, the system suspend/resume directly call
> the runtime suspend/resume functions
> and remove the wapper of CONFIG_PM_RUNTIME, CONFIG_PM_SLEEP.
>
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Acked-by: Kevin Hilman <khilman@linaro.org>
