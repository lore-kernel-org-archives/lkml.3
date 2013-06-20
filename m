Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935633Ab3FTC41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:56:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57286 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935506Ab3FTC40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:56:26 -0400
Message-ID: <51C26F48.6080604@infradead.org>
Date: Wed, 19 Jun 2013 19:56:08 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        jamie@jamieiles.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: linux-next: Tree for Jun 19 (serial/8250/8250_dw.c)
References: <20130619182115.e5786a389561898e8dce178d@canb.auug.org.au>
In-Reply-To: <20130619182115.e5786a389561898e8dce178d@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/13 01:21, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130618:
> 


on i386:

drivers/tty/serial/8250/8250_dw.c: In function 'dw8250_serial_inq':
drivers/tty/serial/8250/8250_dw.c:68:2: error: implicit declaration of function '__raw_readq' [-Werror=implicit-function-declaration]
drivers/tty/serial/8250/8250_dw.c: In function 'dw8250_serial_outq':
drivers/tty/serial/8250/8250_dw.c:79:2: error: implicit declaration of function '__raw_writeq' [-Werror=implicit-function-declaration]


-- 
~Randy
