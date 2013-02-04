Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab3BDUkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:40:25 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:57304 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3BDUkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:40:24 -0500
MIME-Version: 1.0
In-Reply-To: <1359854463-2538-15-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
	<1359854463-2538-15-git-send-email-tj@kernel.org>
Date: Mon, 4 Feb 2013 21:40:23 +0100
Message-ID: <CACRpkdb_an_OSynCzu0nLkRaBQ8uYbyvGojySbSdCnp1-1AOSQ@mail.gmail.com>
Subject: Re: [PATCH 14/62] gpio: convert to idr_alloc()
From: Linus Walleij <linus.walleij@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 3, 2013 at 2:20 AM, Tejun Heo <tj@kernel.org> wrote:

> Convert to the much saner new idr interface.
>
> Only compile tested.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
> This patch depends on an earlier idr changes and I think it would be
> best to route these together through -mm.  Please holler if there's
> any objection.  Thanks.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
