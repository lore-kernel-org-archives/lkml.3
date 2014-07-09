Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbaGIRXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:23:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:43488 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaGIRXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:23:48 -0400
Message-ID: <53BD7A9D.2070605@linutronix.de>
Date: Wed, 09 Jul 2014 19:23:41 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com
Subject: Re: [RFC PATCH 1/4] tty: serial: 8250 core: provide a function to
 export uart_8250_port
References: <1404491651-1388-1-git-send-email-bigeasy@linutronix.de> <20140707140911.5ee517d2@alan.etchedpixels.co.uk>
In-Reply-To: <20140707140911.5ee517d2@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 03:09 PM, One Thousand Gnomes wrote:
> Please update the patch to clearly describe the locking
> assumptions/requirements for the caller (and not to use it unless you
> have no other choice)

done.

Sebastian
