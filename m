Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935760Ab3DPOXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 10:23:03 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:10964 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933715Ab3DPOXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 10:23:01 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Lars-Peter Clausen <lars@metafoo.de>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: RE: [NEW DRIVER V4 2/7] DA9058 ADC driver
Thread-Topic: [NEW DRIVER V4 2/7] DA9058 ADC driver
Thread-Index: AQHON4Cu87eN7rzPxU6Pdq/9UK3kdpjSsXgAgAY5tKA=
Date: Tue, 16 Apr 2013 14:22:59 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB514191E442@NB-EX-MBX02.diasemi.com>
References: <201304121320.r3CDKLNL013219@latitude>
 <51683294.40908@metafoo.de>
In-Reply-To: <51683294.40908@metafoo.de>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.109]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [...]
> please always test your drivers against the latest upstream version before submitting them.
> [...]

Hi Lars,

The driver was tested against linux mainline tag v3.9-rc6, because that was the most recent
tagged commit in git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git on the day
that I sent in the patches.

What exactly do you mean by "latest upstream version" ?
Did I use the correct repository ?

Tony Olech
