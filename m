Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565AbaFSPLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:11:23 -0400
Received: from sam.nabble.com ([216.139.236.26]:43060 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805AbaFSPLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:11:22 -0400
Date: Thu, 19 Jun 2014 08:11:21 -0700 (PDT)
From: tdjames <tdjames@umd.edu>
To: linux-kernel@vger.kernel.org
Message-ID: <1403190681610-885003.post@n7.nabble.com>
Subject: How to disable Lazy Preempt in the kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm relatively new to Linux and working on getting a real-time kernel up and
running for robot applications. I'm on Ubuntu 14.04, using kernel 3.14.3 and
the 3.14.3-rt5 real-time patch. Also using x86-64.

There's a known error where the whole system crashes under some load when
lazy preempt is enabled. This has happened to me a few times now. My
question is:

How do I disable lazy preempt?

Thanks for the help!

-Tom



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/How-to-disable-Lazy-Preempt-in-the-kernel-tp885003.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
