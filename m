Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3IVRFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:05:45 -0400
Received: from plane.gmane.org ([80.91.229.3]:55196 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab3IVRFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:05:44 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Would an "information module" be useful?
Date: Sun, 22 Sep 2013 19:05:31 +0200
Message-ID: <l1n80j$ofi$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: f048038158.adsl.alicedsl.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I became interested in an use case where I want to pass customised data from the
boot command-line to other user processes. I have read the available
documentation in the way that kernel modules provide such a means to get
additional parameters recorded.

I have got the understanding that a kernel module provides also a name space for
such boot parameters. (Are they also called "attributes" there?)
Now I would be interested to create a module for my needs so that the passed
data will be stored in the sys file system. Which software component is
responsible for this task?

I find that another implementation detail needs more clarification. The modules
usually drive some hardware.
https://www.kernel.org/doc/Documentation/filesystems/sysfs.txt

But I am looking for a kind of kernel module which does not serve any hardware.
I imagine that it should be sufficient to register it as a simple information sink.

How do you think about my considerations?
Would you like to share any alternative ideas?

Regards,
Markus

