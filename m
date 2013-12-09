Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108Ab3LIQfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:35:34 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:15680 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989Ab3LIQf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:35:29 -0500
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5k/CuK2S920=
X-RZG-CLASS-ID: mo00
Message-ID: <52A5F14B.6080301@hartkopp.net>
Date: Mon, 09 Dec 2013 17:35:23 +0100
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Sebastian Haas <dev@sebastianhaas.info>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] can: ems_usb: fix urb leaks on failure paths
References: <1386371435-17597-1-git-send-email-khoroshilov@ispras.ru> <52A309BE.7000602@hartkopp.net> <52A59E7A.5060605@pengutronix.de>
In-Reply-To: <52A59E7A.5060605@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09.12.2013 11:42, Marc Kleine-Budde wrote:
> On 12/07/2013 12:42 PM, Oliver Hartkopp wrote:
>> Hello Alexey,
>>
>> looks better :-)
> 
> Is this an Acked-by?
> 

No it was not. I'm not a USB specialist ;-)

That's why I asked Sebastian for his Acked-by, which he did here:

http://marc.info/?l=linux-can&m=138652222410554&w=2

Regards,
Oliver
