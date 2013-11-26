Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab3KZWhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 17:37:47 -0500
Received: from void.printf.net ([89.145.121.20]:58158 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756764Ab3KZWhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 17:37:46 -0500
From: Chris Ball <cjb@laptop.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] mmc: tmio: remove myself as a maintainer
References: <Pine.LNX.4.64.1311230953420.9194@axis700.grange>
Date: Tue, 26 Nov 2013 17:37:36 -0500
In-Reply-To: <Pine.LNX.4.64.1311230953420.9194@axis700.grange> (Guennadi
	Liakhovetski's message of "Sat, 23 Nov 2013 09:54:39 +0100 (CET)")
Message-ID: <87vbzeeqmn.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Sat, Nov 23 2013, Guennadi Liakhovetski wrote:
> Since I'm currently unable to dedicate sufficient time to driver
> maintainership, remove myself from the maintainers list.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  MAINTAINERS |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b5f4e68..e37e8c0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8643,7 +8643,6 @@ F:	include/linux/toshiba.h
>  F:	include/uapi/linux/toshiba.h
>  
>  TMIO MMC DRIVER
> -M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>  M:	Ian Molton <ian@mnementh.co.uk>
>  L:	linux-mmc@vger.kernel.org
>  S:	Maintained

Pushed to mmc-next for 3.14.  Thanks for all your work up to now!

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
