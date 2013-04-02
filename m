Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab3DBXvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:51:25 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:48573 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab3DBXvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:51:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: James Hogan <james.hogan@imgtec.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1364222107-1079-1-git-send-email-james.hogan@imgtec.com>
Cc: James Hogan <james.hogan@imgtec.com>
References: <1364222107-1079-1-git-send-email-james.hogan@imgtec.com>
Message-ID: <20130402235118.8177.72734@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH 1/1] clk: fix clk_mux::flags kerneldoc
Date: Tue, 02 Apr 2013 16:51:18 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Hogan (2013-03-25 07:35:07)
> The kerneldoc comment for struct clk_mux documented the non-existent
> num_clks instead of flags. Correct this.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>

Thanks for the fix.  Taken into clk-next.

Regards,
Mike

> ---
>  include/linux/clk-provider.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index cdad3ce..e7504d5 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -276,7 +276,7 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
>   * @reg:       register controlling multiplexer
>   * @shift:     shift to multiplexer bit field
>   * @width:     width of mutliplexer bit field
> - * @num_clks:  number of parent clocks
> + * @flags:     hardware-specific flags
>   * @lock:      register lock
>   *
>   * Clock with multiple selectable parents.  Implements .get_parent, .set_parent
> -- 
> 1.8.1.2
