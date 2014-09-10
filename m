Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaIJOZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:25:50 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:51464 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaIJOZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:25:48 -0400
Date: Wed, 10 Sep 2014 10:25:38 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Punit Agrawal <punit.agrawal@arm.com>, Rui Zhang <rui.zhang@intel.com>,
        Javi Merino <javi.merino@arm.com>, Wei Ni <wni@nvidia.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFT] PID based thermal governor
Message-ID: <20140910142536.GA8858@developer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hello Folks,

Javi and Punit have been sending a series of patches that add a PID
thermal governor. I have been reviewing the series and I believe it is
getting into a good shape already.

For this reason, I am sending this request for test. The patch set is
based on my next branch. I have pulled their changes into a branch
located here:
https://git.kernel.org/cgit/linux/kernel/git/evalenti/linux.git/log/?h=thermal_work/thermal_core/power_allocator

They also include the concept of power allocation mechanism. For now, I
am interested to see how the governor behaves in other platforms. I have
given it a try on the boards I have available, which are mainline OMAP
and Exynos based.

Cheers,

Eduardo Valentin
