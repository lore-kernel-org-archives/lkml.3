Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3AOHlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 02:41:24 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:44656 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab3AOHlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 02:41:23 -0500
Date: Tue, 15 Jan 2013 08:41:20 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Cong Ding <dinggnu@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avr32: boards/atngw100/mrmt.c: fix build error
Message-ID: <20130115074120.GA15660@samfundet.no>
References: <1358199833-15769-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358199833-15769-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 14 Jan 2013 22:43:51 +0100 or thereabout, Cong Ding wrote:
> there is an extra "} in the file, so we delete it.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/boards/atngw100/mrmt.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/avr32/boards/atngw100/mrmt.c b/arch/avr32/boards/atngw100/mrmt.c
> index f914319..7de083d 100644
> --- a/arch/avr32/boards/atngw100/mrmt.c
> +++ b/arch/avr32/boards/atngw100/mrmt.c
> @@ -150,7 +150,6 @@ static struct ac97c_platform_data __initdata ac97c0_data = {
>  static struct platform_device rmt_ts_device = {
>  	.name	= "ucb1400_ts",
>  	.id	= -1,
> -	}
>  };
>  #endif
>  
-- 
mvh
Hans-Christian Egtvedt
