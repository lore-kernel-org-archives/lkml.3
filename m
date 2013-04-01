Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3DARLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:11:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:49407 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab3DARLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:11:35 -0400
Message-ID: <5159B1BD.50703@infradead.org>
Date: Mon, 01 Apr 2013 09:11:41 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: linux-kernel@vger.kernel.org, jforbes@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] DocBook/device-drivers.tmpl: fix 8250.c reference
References: <20130401164230.GO12938@bombadil.infradead.org>
In-Reply-To: <20130401164230.GO12938@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/13 09:42, Kyle McMartin wrote:
> htmldocs will fail, because device-drivers.tmpl references the
> non-existant file 8250.c (which got renamed to 8250_core.c)
> 

This is a fatal docbook error.

> Signed-off-by: Kyle McMartin <kyle@redhat.com>

Yes, I was about to make this same patch.  Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> 
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
> --


-- 
~Randy
