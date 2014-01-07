Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaAGKs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:48:29 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:27582 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaAGKs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:48:27 -0500
Message-ID: <52CBDB78.3050306@atmel.com>
Date: Tue, 7 Jan 2014 11:48:24 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>
CC: Leilei Zhao <leilei.zhao@atmel.com>, <mark.roszko@gmail.com>,
        <mdeneen@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 0/4] tty/serial: at91: fixes dealing with port shutdown
References: <cover.1389090437.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1389090437.git.nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 11:41, Nicolas Ferre :
> Hi,

Sorry for the noise: I messed up with git-send-email...

I re-sent the whole series.

Bye,


> These four fixes are pretty important for our atmel_serial driver as they
> deal with closing/re-opening of ports. They fix race condition and
> null pointers dereference.
> I added the "stable" tag to each of them (v3.12).
> 
> Even if we are late in the development cycle, can you please consider including
> these patches for 3.13?
> 
> Thanks, best regards,
>    Nicolas Ferre
> 
> Marek Roszko (3):
>   tty/serial: at91: Handle shutdown more safely
>   tty/serial: at91: fix race condition in atmel_serial_remove
>   tty/serial: at91: prevent null dereference in tasklet function
> 
> Mark Deneen (1):
>   tty/serial: at91: reset rx_ring when port is shutdown
> 
>  drivers/tty/serial/atmel_serial.c | 27 ++++++++++++++++++++++-----
>  1 file changed, 22 insertions(+), 5 deletions(-)
> 


-- 
Nicolas Ferre
