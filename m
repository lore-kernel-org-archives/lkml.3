Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3AOQCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:02:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab3AOQCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:02:31 -0500
Date: Tue, 15 Jan 2013 17:02:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando_b1@lab.ntt.co.jp>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH v2] HID: add support for Sony RF receiver with USB product
 id 0x0374
In-Reply-To: <1358246448.4897.3.camel@nexus.lab.ntt.co.jp>
Message-ID: <alpine.LNX.2.00.1301151702150.7734@pobox.suse.cz>
References: <1358221428.9926.1.camel@nexus.lab.ntt.co.jp>  <20130115103638.be566e39f0f5ad7186362dd8@studenti.unina.it>  <50F52986.2080002@lab.ntt.co.jp> <1358246448.4897.3.camel@nexus.lab.ntt.co.jp>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013, Fernando Luis Vázquez Cao wrote:

> Some Vaio desktop computers, among them the VGC-LN51JGB multimedia PC, have
> a RF receiver, multi-interface USB device 054c:0374, that is used to connect
> a wireless keyboard and a wireless mouse.
> 
> The keyboard works flawlessly, but the mouse (VGP-WMS3 in my case) does not
> seem to be generating any pointer events. The problem is that the mouse pointer
> is wrongly declared as a constant non-data variable in the report descriptor
> (see lsusb and usbhid-dump output below), with the consequence that it is
> ignored by the HID code.
> 
> Add this device to the have-special-driver list and fix up the report
> descriptor in the Sony-specific driver which happens to already have a fixup
> for a similar firmware bug.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
