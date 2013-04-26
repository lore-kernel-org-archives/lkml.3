Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3DZXF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 19:05:57 -0400
Received: from [201.191.100.135] ([201.191.100.135]:36295 "EHLO
	bruno.wildbear.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3DZXF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 19:05:56 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Apr 2013 19:05:56 EDT
Date: Fri, 26 Apr 2013 16:57:18 -0600 (CST)
From: Joseph Parmelee <jparmele@wildbear.com>
X-X-Sender: jparmele@bruno
To: linux-kernel@vger.kernel.org
Subject: Real Time Clock
Message-ID: <alpine.LNX.2.00.1304261607460.2465@bruno>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regards to all:

I have been playing heavily with NTP recently and have encountered several
problems which prevent its complete usage.  I am not sure at this time
whether this latest problem (which appears to have security implications) is
in the kernel or coming from user space via ntpd.

Please help me find this.  Can someone list the conditions (if any) under
which the kernel changes the RTC under its own volition?  (As opposed to a
specific instruction from user space, like an ioctl).

Best regards,

Joseph Parmelee
jpar m ele at wild b ear dot c o m.
Thanks very much.
