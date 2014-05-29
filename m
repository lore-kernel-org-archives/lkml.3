Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbaE2EkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:40:01 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43201 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbaE2Ejx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:39:53 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 1/2] perf script: move the number processing into its own function
References: <1401207274-8170-1-git-send-email-bigeasy@linutronix.de>
Date: Thu, 29 May 2014 13:39:49 +0900
In-Reply-To: <1401207274-8170-1-git-send-email-bigeasy@linutronix.de>
	(Sebastian Andrzej Siewior's message of "Tue, 27 May 2014 18:14:33
	+0200")
Message-ID: <87ha49gpuy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Tue, 27 May 2014 18:14:33 +0200, Sebastian Andrzej Siewior wrote:
> I was going to change something here and the result was so much on the
> right side of the screen that I decided to move that piece into its own
> function.
> This patch should make no function change except the moving the code
> into its own function.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
