Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbaITSUQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 14:20:16 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33493 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508AbaITSUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 14:20:14 -0400
Message-ID: <541DC55A.9080702@gmail.com>
Date: Sat, 20 Sep 2014 20:20:10 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH] clk: s5pv210: add missing call to samsung_clk_of_add_provider()
References: <1411117216-11456-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1411117216-11456-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.09.2014 11:00, Marek Szyprowski wrote:
> Commit d5e136a21b2028fb1f45143ea7112d5869bfc6c7 ("clk: samsung: Register
> clk provider only after registering its all clocks", merged to v3.17-rc1)
> modified a way that driver registers registers to core framework. This
> change has not been applied to s5pv210 clocks driver, which has been
> merged in parallel to that commit. This patch adds a missing call to
> samsung_clk_of_add_provider(), so the driver is operational again.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
> Hello!
> 
> This is an important fix to v3.17-rcX. Without it support for Samsung
> S5PV210 SoCs is not functional.
> 
> Mike, could you take it to the fixes branch?

Acked-by: Tomasz Figa <tomasz.figa@gmail.com>

Mike, since it seems like this is the only fix to be queued for next -rc
release, I think it would be reasonable if you picked it up directly.

Best regards,
Tomasz
