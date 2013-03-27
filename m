Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3C0Iqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:46:39 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:64950 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab3C0Iqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:46:35 -0400
MIME-Version: 1.0
In-Reply-To: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
References: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
Date: Wed, 27 Mar 2013 09:46:34 +0100
Message-ID: <CACRpkda6tPYbwtEvGzr-7TJdFN_gEYpgr5JSDTLELPSQaY4P7A@mail.gmail.com>
Subject: Re: [PATCH 1/6] gpio: adp5520: use devm_kzalloc()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 10:14 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Use devm_kzalloc() to make cleanup paths simpler.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.

Thanks!
Linus Walleij
