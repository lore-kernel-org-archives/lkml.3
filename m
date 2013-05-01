Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015Ab3EAAZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 20:25:22 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:46002 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933881Ab3EAAZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 20:25:20 -0400
Message-ID: <1367367906.4712.4.camel@nexus>
Subject: Re: [PATCH v2] HID: add support for Sony RF receiver with USB
 product id 0x0374
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antonio Ospite <ospite@studenti.unina.it>
Date: Wed, 01 May 2013 09:25:06 +0900
In-Reply-To: <alpine.LNX.2.00.1301151702150.7734@pobox.suse.cz>
References: <1358221428.9926.1.camel@nexus.lab.ntt.co.jp>
	  <20130115103638.be566e39f0f5ad7186362dd8@studenti.unina.it>
	  <50F52986.2080002@lab.ntt.co.jp>
	 <1358246448.4897.3.camel@nexus.lab.ntt.co.jp>
	 <alpine.LNX.2.00.1301151702150.7734@pobox.suse.cz>
Organization: NTT Open Source Software Center
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, 2013-01-15 at 17:02 +0100, Jiri Kosina wrote:
> On Tue, 15 Jan 2013, Fernando Luis Vázquez Cao wrote:
> 
> > Some Vaio desktop computers, among them the VGC-LN51JGB multimedia PC, have
> > a RF receiver, multi-interface USB device 054c:0374, that is used to connect
> > a wireless keyboard and a wireless mouse.
> > 
> > The keyboard works flawlessly, but the mouse (VGP-WMS3 in my case) does not
> > seem to be generating any pointer events. The problem is that the mouse pointer
> > is wrongly declared as a constant non-data variable in the report descriptor
> > (see lsusb and usbhid-dump output below), with the consequence that it is
> > ignored by the HID code.
> > 
> > Add this device to the have-special-driver list and fix up the report
> > descriptor in the Sony-specific driver which happens to already have a fixup
> > for a similar firmware bug.
> 
> Applied, thanks.

It looks like after the merge of the the sony and steelseries
branches the hid core hunk was left out, which means that
this fix-up is never applied.

I will be replying to this email with a fix.

Thanks,
Fernando

