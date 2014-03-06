Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaCFF5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 00:57:08 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:65531 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaCFF5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 00:57:07 -0500
MIME-Version: 1.0
In-Reply-To: <975d7885a8b64971923466f9f06a6229@BL2PR03MB226.namprd03.prod.outlook.com>
References: <CAOAoqGuicMKJ8e6kmQ92fL73UpvBzfXx9kafP4tCbUKkiT2=vA@mail.gmail.com>
	<Pine.LNX.4.44L0.1403051101430.1629-100000@iolanthe.rowland.org>
	<975d7885a8b64971923466f9f06a6229@BL2PR03MB226.namprd03.prod.outlook.com>
Date: Thu, 6 Mar 2014 11:27:06 +0530
Message-ID: <CAOAoqGvzxsnpopgi4-DtfUp-zXbq6iV0J_y18Q0NgZ1AGzSu2Q@mail.gmail.com>
Subject: Re: USB remote wakeup through gpio interrupt
From: Jagdish Gedia <jvgediya@gmail.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for your reply.

I can use pm_runtime_get in interrupt handler, but i am not getting
your idea of using pm_runtime_put in interrupt handler?

My device is usb telephony modem, which will give interrupt through
gpio when call comes. so at that time i want to wakeup the usb
functionality as remote wakeup is not working properly.

will pm_runtime_put suspend the device immidiately or it will not
suspend the device till it is in use?


thanks,
jagdish gediya
