Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaCFJXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:23:40 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:48855 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaCFJXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:23:38 -0500
MIME-Version: 1.0
In-Reply-To: <3a0fb59a555b40aca5610ef00626fdba@BL2PR03MB226.namprd03.prod.outlook.com>
References: <CAOAoqGuicMKJ8e6kmQ92fL73UpvBzfXx9kafP4tCbUKkiT2=vA@mail.gmail.com>
	<Pine.LNX.4.44L0.1403051101430.1629-100000@iolanthe.rowland.org>
	<975d7885a8b64971923466f9f06a6229@BL2PR03MB226.namprd03.prod.outlook.com>
	<CAOAoqGvzxsnpopgi4-DtfUp-zXbq6iV0J_y18Q0NgZ1AGzSu2Q@mail.gmail.com>
	<3a0fb59a555b40aca5610ef00626fdba@BL2PR03MB226.namprd03.prod.outlook.com>
Date: Thu, 6 Mar 2014 14:53:37 +0530
Message-ID: <CAOAoqGu4exeZP2wgEWpRyD7+4RVRbB=vOe4Hc+rK3CVVigCWvg@mail.gmail.com>
Subject: Re: USB remote wakeup through gpio interrupt
From: Jagdish Gedia <jvgediya@gmail.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

As you have told, i have executed pm_request_resume() function from my
interrupt handler, and it is waking up my USB device. I have
implemented all this functionality in class driver(cdc-acm.c).
but what is happening is after 2-3 times, ausosuspend is getting
disable for my device. I want autosuspend to be enabled for usb device
forever. Do pm_request_resume function causes this behavior?



Thanks,
Jagdish Gediya
