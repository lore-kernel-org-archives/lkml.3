Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab3JQWLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:11:45 -0400
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:38335 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762378Ab3JQWLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:11:44 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH] Bluetooth: Add hci_h4p driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <201310172225.33343@pali>
Date: Fri, 18 Oct 2013 00:11:44 +0200
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>
Content-Transfer-Encoding: 8BIT
Message-Id: <3B0F039C-4680-46FF-A654-48D6A28B9B5E@holtmann.org>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com> <201310172225.33343@pali>
To: =?iso-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pali,

>> This driver adding support for Nokia N900 bluetooth hardware
>> 
>> Signed-off-by: Ville Tervo <ville.tervo@nokia.com>
>> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>> ---
>> drivers/bluetooth/Kconfig             |   10 +
>> drivers/bluetooth/Makefile            |    2 +
>> drivers/bluetooth/hci_h4p/Makefile    |    7 +
>> drivers/bluetooth/hci_h4p/core.c      | 1085
>> +++++++++++++++++++++++++++++++++
>> drivers/bluetooth/hci_h4p/fw-bcm.c    |  149 +++++
>> drivers/bluetooth/hci_h4p/fw-csr.c    |  152 +++++
>> drivers/bluetooth/hci_h4p/fw-ti1273.c |  113 ++++
>> drivers/bluetooth/hci_h4p/fw.c        |  166 +++++
>> drivers/bluetooth/hci_h4p/hci_h4p.h   |  238 ++++++++
>> drivers/bluetooth/hci_h4p/uart.c      |  203 ++++++
>> include/linux/bluetooth/hci_h4p.h     |   41 ++
>> 11 files changed, 2166 insertions(+)
>> create mode 100644 drivers/bluetooth/hci_h4p/Makefile
>> create mode 100644 drivers/bluetooth/hci_h4p/core.c
>> create mode 100644 drivers/bluetooth/hci_h4p/fw-bcm.c
>> create mode 100644 drivers/bluetooth/hci_h4p/fw-csr.c
>> create mode 100644 drivers/bluetooth/hci_h4p/fw-ti1273.c
>> create mode 100644 drivers/bluetooth/hci_h4p/fw.c
>> create mode 100644 drivers/bluetooth/hci_h4p/hci_h4p.h
>> create mode 100644 drivers/bluetooth/hci_h4p/uart.c
>> create mode 100644 include/linux/bluetooth/hci_h4p.h
>> 
> 
> Can somebody look & comment this patch? What is needed to be part 
> of upstream kernel?

you need to rebase against bluetooth-next at least.

Regards

Marcel

