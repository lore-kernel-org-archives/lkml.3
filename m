Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab3CTQoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:44:46 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:57462 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417Ab3CTQoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:44:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Eduardo Valentin <eduardo.valentin@ti.com>, Rob Landley <rob@landley.net>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1362059947-3706-1-git-send-email-eduardo.valentin@ti.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <eduardo.valentin@ti.com>
References: <1362059947-3706-1-git-send-email-eduardo.valentin@ti.com>
Message-ID: <20130320164438.18043.5312@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH 1/1] documentation: clk: fix couple of misspelling
Date: Wed, 20 Mar 2013 09:44:38 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eduardo Valentin (2013-02-28 05:59:07)
> Correcting misspelling inside the clk.txt.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

Thanks Eduardo!  Taken into clk-next.

Regards,
Mike

> ---
>  Documentation/clk.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/clk.txt b/Documentation/clk.txt
> index 1943fae..4274a54 100644
> --- a/Documentation/clk.txt
> +++ b/Documentation/clk.txt
> @@ -174,9 +174,9 @@ int clk_foo_enable(struct clk_hw *hw)
>  };
>  
>  Below is a matrix detailing which clk_ops are mandatory based upon the
> -hardware capbilities of that clock.  A cell marked as "y" means
> +hardware capabilities of that clock.  A cell marked as "y" means
>  mandatory, a cell marked as "n" implies that either including that
> -callback is invalid or otherwise uneccesary.  Empty cells are either
> +callback is invalid or otherwise unnecessary.  Empty cells are either
>  optional or must be evaluated on a case-by-case basis.
>  
>                             clock hardware characteristics
> -- 
> 1.7.7.1.488.ge8e1c
