Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaIAOi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:38:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:59480 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaIAOiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:38:55 -0400
Message-ID: <540484F5.5080705@linutronix.de>
Date: Mon, 01 Sep 2014 16:38:45 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 06/15] tty: serial: 8250_dma: handle error on TX submit
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de> <1408124563-31541-7-git-send-email-bigeasy@linutronix.de> <20140818135737.GB32400@xps8300>
In-Reply-To: <20140818135737.GB32400@xps8300>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2014 03:57 PM, Heikki Krogerus wrote:
> On Fri, Aug 15, 2014 at 07:42:34PM +0200, Sebastian Andrzej Siewior wrote:
>> diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
>> index b161eee..02e82dc 100644
>> --- a/include/linux/serial_8250.h
>> +++ b/include/linux/serial_8250.h
>> @@ -85,6 +85,7 @@ struct uart_8250_port {
>>  	unsigned char		mcr_force;	/* mask of forced bits */
>>  	unsigned char		cur_iotype;	/* Running I/O type */
>>  	unsigned char		rpm_tx_active;
>> +	unsigned char		dma_tx_err;
> 
> Why not make this member of uart_8250_dma instead?

Why not indeed. Fixed.

Sebastian
