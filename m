Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3FJRvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:51:18 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48667 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3FJRvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:51:16 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
Cc: <j-keerthy@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] PM / AVS: SmartReflex: use devm_* API to initialize SmartReflex
References: <1370339913-16135-1-git-send-email-andrii.tseglytskyi@ti.com>
	<1370339913-16135-2-git-send-email-andrii.tseglytskyi@ti.com>
Date: Mon, 10 Jun 2013 10:51:13 -0700
In-Reply-To: <1370339913-16135-2-git-send-email-andrii.tseglytskyi@ti.com>
	(Andrii Tseglytskyi's message of "Tue, 4 Jun 2013 12:58:32 +0300")
Message-ID: <87ppvtdfce.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrii Tseglytskyi <andrii.tseglytskyi@ti.com> writes:

> Use of of devm_* API for resource allocation provides benefits such
> as auto handling of resource free. This reduces possibility have
> memory leaks in case of wrong error handling. All direct release
> calls should be removed to avoid races.
>
> Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>

Thanks, queuing this for v3.11.

Kevin
