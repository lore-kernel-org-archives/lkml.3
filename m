Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3JLKIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 06:08:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51003 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab3JLKIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 06:08:05 -0400
Message-ID: <52591F7A.1020400@ti.com>
Date: Sat, 12 Oct 2013 15:37:54 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arokux X <arokux@gmail.com>
CC: <peter.chen@freescale.com>, Felipe Balbi <balbi@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: When USB PHY framework should be used?
References: <CAPNxggauvgpWR5HK4Z-Osv7-mB-Tf3-vfyXQDMiTx08K2M=nJQ@mail.gmail.com> <52579592.1020209@ti.com> <CAPNxgga6xSPrGPWnKJuamMURQdrX0_Hkhx_ZDdS2dcUgs72EKw@mail.gmail.com>
In-Reply-To: <CAPNxgga6xSPrGPWnKJuamMURQdrX0_Hkhx_ZDdS2dcUgs72EKw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 11 October 2013 10:52 PM, Arokux X wrote:
>> I think you should have a wrapper driver to EHCI/OHCI to handle this reset.
> 
> Thank you Kishon and Peter for the quick replies. Is there any good
> example of such a wrapper driver in the kernel already?

can you explain how your IP actually looks like? Do you have separate address
space for EHCI and OHCI? Do you have any common address space for doing some
configuration (USB host in OMAP used to have it)? Where does PHY registers
reside exactly?

Thanks
Kishon
