Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaGIRjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:39:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:43612 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaGIRjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:39:48 -0400
Message-ID: <53BD7E5E.7020203@linutronix.de>
Date: Wed, 09 Jul 2014 19:39:42 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com
Subject: Re: [RFC PATCH 2/4] tty: serial: 8250 core: allow to overwrite &
 export serial8250_startup()
References: <1404491651-1388-1-git-send-email-bigeasy@linutronix.de>	<1404491651-1388-2-git-send-email-bigeasy@linutronix.de> <20140707140946.6f16f2e4@alan.etchedpixels.co.uk>
In-Reply-To: <20140707140946.6f16f2e4@alan.etchedpixels.co.uk>
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
> On Fri,  4 Jul 2014 18:34:09 +0200
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> 
>> The OMAP version of the 8250 can actually use 1:1 serial8250_startup().
>> However it needs to be extended by a wakeup irq which should to be
>> requested & enabled at ->startup() time.
>>
>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> Acked-by: Alan Cox <alan@linux.intel.com>

Thank you. I added to this patch the counterpart function (->shutdown)
and therefore not yet adding the acked-by.

Sebastian
