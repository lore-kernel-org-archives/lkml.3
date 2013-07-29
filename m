Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab3G2JcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:32:12 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:49568 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3G2JcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:32:11 -0400
Date: Mon, 29 Jul 2013 11:32:07 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Cong Ding <dinggnu@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avr32: boards/atngw100/mrmt.c: fix building error
Message-ID: <20130729093207.GA10624@samfundet.no>
References: <1374966478-16279-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374966478-16279-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sat 27 Jul 2013 19:07:51 -0400 or thereabout, Cong Ding wrote:
> there is an additional "{", which causes building error.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/boards/atngw100/mrmt.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/avr32/boards/atngw100/mrmt.c b/arch/avr32/boards/atngw100/mrmt.c
> index ccc9599..1ba09e4 100644
> --- a/arch/avr32/boards/atngw100/mrmt.c
> +++ b/arch/avr32/boards/atngw100/mrmt.c
> @@ -150,7 +150,6 @@ static struct ac97c_platform_data __initdata ac97c0_data = {
>  static struct platform_device rmt_ts_device = {
>  	.name	= "ucb1400_ts",
>  	.id	= -1,
> -	}
>  };
>  #endif

Thank you for the fix, added to the for-linus branch in my
git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32.git tree.

I'll see if there are any minor changes also needed before sending a pull
request to upstream.

-- 
mvh
Hans-Christian Egtvedt
