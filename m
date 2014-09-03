Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbaICQqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:46:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:41121 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbaICQqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:46:43 -0400
Message-ID: <540745ED.1020307@infradead.org>
Date: Wed, 03 Sep 2014 09:46:37 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] tty: doc: Fix typos in serial/tty
References: <1409759628-25754-1-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1409759628-25754-1-git-send-email-richard.genoud@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/14 08:53, Richard Genoud wrote:
> Correct spelling typos in serial/tty
> 
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

Jiri, can you take this, please?


> ---
>  Documentation/serial/tty.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/serial/tty.txt b/Documentation/serial/tty.txt
> index 540db41dfd5d..1e52d67d0abf 100644
> --- a/Documentation/serial/tty.txt
> +++ b/Documentation/serial/tty.txt
> @@ -146,7 +146,7 @@ set_termios()		Notify the tty driver that the device's termios
>  			driver function is responsible for modifying any
>  			bits in the request it cannot fulfill to indicate
>  			the actual modes being used. A device with no
> -			hardware capability for change (eg a USB dongle or
> +			hardware capability for change (e.g. a USB dongle or
>  			virtual port) can provide NULL for this method.
>  
>  throttle()		Notify the tty driver that input buffers for the
> @@ -258,7 +258,7 @@ put_char()	-	Stuff a single character onto the queue. The
>  
>  flush_chars()	-	Ask the kernel to write put_char queue
>  
> -write_room()	-	Return the number of characters tht can be stuffed
> +write_room()	-	Return the number of characters that can be stuffed
>  			into the port buffers without overflow (or less).
>  			The ldisc is responsible for being intelligent
>   			about multi-threading of write_room/write calls
> 


-- 
~Randy
