Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbaE2Pf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:35:27 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:60474 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219AbaE2Pf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:35:26 -0400
Message-ID: <538753BB.6060500@dev.rtsoft.ru>
Date: Thu, 29 May 2014 19:35:23 +0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH] usb: pci-quirks: do not access OHCI_FMINTERVAL register
 on ULI hw
References: <Pine.LNX.4.44L0.1405281014320.1552-100000@iolanthe.rowland.org>	<5386C6F9.7070202@dev.rtsoft.ru>	<5387450C.7030207@dev.rtsoft.ru> <20140529154217.6248ae95@alan.etchedpixels.co.uk> <53875339.7050408@dev.rtsoft.ru>
In-Reply-To: <53875339.7050408@dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

29.05.2014 19:33, Nikita Yushchenko пишет:
> 29.05.2014 18:42, One Thousand Gnomes пишет:
>>> I don't know how linux usb subsystem should behave against such
>>> "half-existing" hardware. Perhaps hanging is not the best idea...
>>> but maybe it should be fixed elsewhere, e.g. by masking non-wired
>>> devices in platform PCI setup. Perhaps controlled by some device-tree
>>> key.
>>
>> Does it have a unique svid/sdid set for the platform - if so you could
>> just blacklist that combination of vid/did/svid/sdid.
> 
> Unfortunately vid/did/svid/sdid come from ULI 1553 southbridge chip,
> that is used by other hardware as well. AFAIK it is still being
> manufactured, and could appear in PCs or laptops.

Sorry I mistyped in entire thread... Chip is ULI M1575.

Nikita

