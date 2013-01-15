Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3AOHWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 02:22:23 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:49196 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3AOHWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 02:22:22 -0500
Message-ID: <1358234563.6868.13.camel@gitbox>
Subject: rtc: vt8500: Fix year field in vt8500_rtc_set_time
From: Tony Prisk <linux@prisktech.co.nz>
To: Greg KH <gregkh@linuxfoundation.org>, a.zummo@towertech.it
Cc: linux-kernel@vger.kernel.org,
        Arm Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        arm@kernel.org, rtc-linux@googlegroups.com
Date: Tue, 15 Jan 2013 20:22:43 +1300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro,

This patch was sent out at the same time as two other RTC fixes for
vt8500 but this one seems to have stopped somewhere along the way while
the other two have been accepted.

The patch is showing in the RTC patch system along with the other two:
http://patchwork.ozlabs.org/patch/208756/


Greg,
How did the first two patches find their way to you - did you pick them
up off one of the lists?

patch 1 - rtc: vt8500: Fix handling of data passed in struct rtc_time
patch 2 - [fix-3.8] rtc: vt8500: Correct handling of CR_24H bitfield

Hope this is enough information to help you figure out what I'm talking
about :)


Regards
Tony P

