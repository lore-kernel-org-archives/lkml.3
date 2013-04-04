Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761976Ab3DDArw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:47:52 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:23440
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758736Ab3DDArv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:47:51 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.231;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail04v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz4015Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1b0ah1155h)
Message-ID: <515CCEB3.4020309@am.sony.com>
Date: Wed, 3 Apr 2013 17:52:03 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: GPS driver for Linux - kernel or user-space driver?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been approached by a developer at Sony who wants to publish an
open source driver for a Sony GPS receiver module.

I've looked in the kernel source, and only see one standalone GPS
driver, for Garmin.  It appears that most GPS support in Linux is done
via user-space drivers.  Many GPS hardware modules appear to be
accessed via a serial line, or USB/serial port.  The Sony
module is pretty much the same, accepting commands and delivering
data via a uart from the chip.

I planning to recommend writing a user-space driver (based on
gpsd and/or the Android GPS HAL specification).  But I'm worried
I'm missing something.  Is this the correct approach, or is there
an established kernel API for GPS modules - such that I should
recommend that this developer writes a kernel module instead
of, or in addition to, the user-space support for the hardware?

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

