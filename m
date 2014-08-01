Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaHAM2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:28:34 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:44703 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbaHAM2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:28:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140801132343.45153300@alan.etchedpixels.co.uk>
References: <CAPybu_1Ma+7nGaS0e17HpPcM1vk6ANSFN3C8MNR=JxWrBBmMOA@mail.gmail.com>
 <1406834546-23033-1-git-send-email-ricardo.ribalda@gmail.com> <20140801132343.45153300@alan.etchedpixels.co.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 1 Aug 2014 14:28:11 +0200
Message-ID: <CAPybu_2U2jjyY_9gji41mUc5F4N+idDVNO=LAr3F5PpJ0JzYSg@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] serial: Add support for Fintek F81216A LPC to 4 UART
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Michael Welling <mwelling@ieee.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Joe Schultz <jschultz@xes-inc.com>, Ingo Molnar <mingo@elte.hu>,
        Doug Anderson <dianders@chromium.org>, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>
> This half of things looks good to me.


Thanks!, What about the other half? Would you accept a two step approach?

1st: add support for 8250_core
2nd: handle rs485 ioctl on serial_core and modify all the other
drivers to use that? (to avoid code duplication)

Thanks


-- 
Ricardo Ribalda
