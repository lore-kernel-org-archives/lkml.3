Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab3JKRWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 13:22:17 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:47646 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab3JKRWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 13:22:15 -0400
MIME-Version: 1.0
In-Reply-To: <52579592.1020209@ti.com>
References: <CAPNxggauvgpWR5HK4Z-Osv7-mB-Tf3-vfyXQDMiTx08K2M=nJQ@mail.gmail.com>
	<52579592.1020209@ti.com>
Date: Fri, 11 Oct 2013 19:22:13 +0200
Message-ID: <CAPNxgga6xSPrGPWnKJuamMURQdrX0_Hkhx_ZDdS2dcUgs72EKw@mail.gmail.com>
Subject: Re: When USB PHY framework should be used?
From: Arokux X <arokux@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>, peter.chen@freescale.com
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you should have a wrapper driver to EHCI/OHCI to handle this reset.

Thank you Kishon and Peter for the quick replies. Is there any good
example of such a wrapper driver in the kernel already?

Thanks
Arokux
