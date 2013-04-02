Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470Ab3DBReC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:34:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:54490 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab3DBReA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:34:00 -0400
Message-ID: <515B0877.3010804@infradead.org>
Date: Tue, 02 Apr 2013 09:33:59 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Documentation: fix a path in a DocBook template
References: <Pine.LNX.4.64.1304021830470.31999@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1304021830470.31999@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/13 09:39, Guennadi Liakhovetski wrote:
> A wrong path to a driver breaks DocBook built.
> 
> Cc: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

from yesterday:
http://marc.info/?l=linux-kernel&m=136483456212321&w=2

anyway, again:
Acked-by: Randy Dunlap <rdunlap@infradead.org>


Thanks.

> ---
> 
> A fix for 3.9
> 
>  Documentation/DocBook/device-drivers.tmpl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
> index 7514dbf..c36892c 100644
> --- a/Documentation/DocBook/device-drivers.tmpl
> +++ b/Documentation/DocBook/device-drivers.tmpl
> @@ -227,7 +227,7 @@ X!Isound/sound_firmware.c
>    <chapter id="uart16x50">
>       <title>16x50 UART Driver</title>
>  !Edrivers/tty/serial/serial_core.c
> -!Edrivers/tty/serial/8250/8250.c
> +!Edrivers/tty/serial/8250/8250_core.c
>    </chapter>
>  
>    <chapter id="fbdev">
> 


-- 
~Randy
