Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3FOBlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 21:41:40 -0400
Received: from mailgw02.dd24.net ([193.46.215.43]:35771 "EHLO
	mailgw02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab3FOBlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 21:41:39 -0400
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jun 2013 21:41:39 EDT
Message-ID: <1371259861.12984.6.camel@heisenberg.scientia.net>
Subject: support for Intel Atom based QNAP LEDs/buttons/buzzer in Linux?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-kernel@vger.kernel.org
Date: Sat, 15 Jun 2013 03:31:01 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I wondered whether anyone knows, whether the kernel supports the
LEDs/buttons/buzzer of Intel Atom based QNAP NAS like the TS-569 Pro?

I got the two line LCD, which is a A125, working,...it can easily be
controlled via the serial device... but not the others.
Seems these are GPIO controlled...

I further found this: https://github.com/tomtastic/qnap-gpio/
but it seems it's for the TS-239 Pro only.

Any people out there with some experience? :)

Cheers and thanks,
Chris.

