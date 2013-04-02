Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab3DBQoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:44:10 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51483 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759537Ab3DBQoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:44:08 -0400
Message-ID: <515B0B08.4090203@suse.cz>
Date: Tue, 02 Apr 2013 18:44:56 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Landley <rob@landley.net>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Documentation: fix a path in a DocBook template
References: <Pine.LNX.4.64.1304021830470.31999@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1304021830470.31999@axis700.grange>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 06:39 PM, Guennadi Liakhovetski wrote:
> A wrong path to a driver breaks DocBook built.
> 
> Cc: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Yes, thanks for fixing.

Acked-by: Jiri Slaby <jslaby@suse.cz>

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
js
suse labs
