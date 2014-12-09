Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaLITHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:07:53 -0500
Received: from senator.holtmann.net ([87.106.208.187]:44773 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaLITHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:07:52 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: __hci_cmd_sync() not suitable for nokia h4p
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20141209190210.GA15641@amd>
Date: Tue, 9 Dec 2014 20:07:45 +0100
Cc: =?utf-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>, sre@debian.org,
        Sebastian Reichel <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, tony@atomide.com,
        khilman@kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <304050AD-DB11-4A2B-A1F7-8B1BBB5F04F0@holtmann.org>
References: <20141209190210.GA15641@amd>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> Major problem with Nokia H4P driver was, that it uses custom functions
> instead of __hci_cmd_sync().

the __hci_cmd_sync is for sending HCI commands and not low-level protocol transports like H:4 or similar. So you want to separate the actual transport of HCI from the firmware loading.

Regards

Marcel

