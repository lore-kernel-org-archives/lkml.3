Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3AVUKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 15:10:19 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:42475 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab3AVUKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 15:10:17 -0500
Date: Tue, 22 Jan 2013 21:10:02 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update avr32 web ressources
Message-ID: <20130122201002.GA11758@samfundet.no>
References: <1358874981-8655-1-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358874981-8655-1-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 22 Jan 2013 18:16:21 +0100 or thereabout, Matthias Brugger wrote:
> Web ressource http://avr32linux.org is no longer
> available. This patch deletes the corresponding line.
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3105c48..e9c1746 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1489,7 +1489,6 @@ AVR32 ARCHITECTURE
>  M:	Haavard Skinnemoen <hskinnemoen@gmail.com>
>  M:	Hans-Christian Egtvedt <egtvedt@samfundet.no>
>  W:	http://www.atmel.com/products/AVR32/
> -W:	http://avr32linux.org/

Actually, it is available at http://mirror.egtvedt.no/avr32linux.org/ which
will be up as long as I'm maintainer. The link above should reflect that
though.

>  W:	http://avrfreaks.net/
>  S:	Maintained
>  F:	arch/avr32/

-- 
mvh
Hans-Christian Egtvedt
