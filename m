Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3C3Lh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 07:37:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54182 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3C3Lh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 07:37:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 1/7] USB: EHCI: make ehci-orion a separate driver
Date: Sat, 30 Mar 2013 11:37:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Russell King <linux@arm.linux.org.uk>
References: <Pine.LNX.4.44L0.1303291342540.1467-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1303291342540.1467-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303301137.21039.arnd@arndb.de>
X-Provags-ID: V02:K0:YxWsbQccyUkbUKnBqtjZRl3USjq3LqZswyKl6GFop/r
 P0CfHv9bqNmdBfCawyJLis6GsGNJm3R5ugeYnwVYlRHk+/4qtD
 JIi0xXe1Qya158uE+Q7qoiJQM0SuK8Nyx6JF95gxLs7dmByHnE
 a3Q5WF20X7yH6OVMGtdCfZw5JW1rVlgfNT+u80pbXDTXUME4/P
 OSiMd8dzCgu2kK4+9ELh5YaijcUcNfLilDfImSeCm2C3y7eLtU
 sc84W6FFwnPnY+WJDiDItalgZRm5fHNtWa6aaemlletmgez2zo
 oComX3eWV0vfUFdIPxuGtAXcvxoUkMzOMubKvqLprj51hEukIp
 0+mEHh74iT0XNReDSjrk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 March 2013, Alan Stern wrote:
> I don't know about this last phrase.  When someone is running "make 
> menuconfig", for example, what shows up is the symbol's description, 
> not the symbol's name.  That person would see "EHCI support for Marvell 
> on-chip controller", not "USB_EHCI_MV".
> 
> In fact, shouldn't the description for USB_EHCI_MV be changed too, to 
> make it more distinct from this one?
> 
> All the code changes are fine.

Ok, I've included these Kconfig changes. Originally, the text change
for PXA/MMP was included in the patch for ehci-mv, but that one is
deferred to 3.11 now because of dependencies for the platform code that
we want to first merge in 3.10.

	Arnd
