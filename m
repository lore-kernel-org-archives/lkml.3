Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaBZWtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:49:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46745 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbaBZWtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:49:32 -0500
Message-ID: <530E6F76.1070605@zytor.com>
Date: Wed, 26 Feb 2014 14:49:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: The sheer number of sparse warnings in the kernel
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of sparse errors in the current kernel is staggering, and it
makes sparse a lot less valuable of a tool that it otherwise could be.
On a build of x86-64 allyesconfig I'm getting 20,676 sparse messages.
Out of those, 12,358 come from linux/err.h.  Given that the latter
basically spams *everything*, I can only conclude that almost noone uses
sparse unless they have a filter script.

So a lot of these are certainly nuisance problems, like the
<linux/err.h> stuff which has to do with the handling of error values,
but some of these look like real bugs.

What do we need to do to actually make our tools be able to do work for
us?  Newbie projects to clean up?  Trying to get the larger Linux
companies to put resources on it?

	-hpa

