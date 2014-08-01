Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbaHAMYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:24:50 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41809 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaHAMYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:24:49 -0400
Date: Fri, 1 Aug 2014 13:23:43 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Michael Welling <mwelling@ieee.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Joe Schultz <jschultz@xes-inc.com>, Ingo Molnar <mingo@elte.hu>,
        Doug Anderson <dianders@chromium.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] serial: Add support for Fintek F81216A LPC to 4
 UART
Message-ID: <20140801132343.45153300@alan.etchedpixels.co.uk>
In-Reply-To: <1406834546-23033-1-git-send-email-ricardo.ribalda@gmail.com>
References: <CAPybu_1Ma+7nGaS0e17HpPcM1vk6ANSFN3C8MNR=JxWrBBmMOA@mail.gmail.com>
	<1406834546-23033-1-git-send-email-ricardo.ribalda@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014 21:22:26 +0200
Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> wrote:

> This patch lets you set the RS485 cappabilites of the device through
> TIOCSRS485 and TIOCGRS485 as defined on Documentation/serial/serial-rs485.txt
> 
> In order to probe the device, the PNP id and the device id is used.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

This half of things looks good to me.

