Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaKWNSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 08:18:47 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51341 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaKWNSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 08:18:45 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/4] i2c: omap: implement workaround for handling invalid BB-bit values
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141123044306.GA19898@saruman>
Date: Sun, 23 Nov 2014 16:18:40 +0300
Cc: Alexander Kochetkov <al.kochet@gmail.com>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <1CC68911-DF20-4FF0-A08A-1A6F0B565662@gmail.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com> <1416518925-20679-3-git-send-email-al.kochet@gmail.com> <20141121160808.GM7508@saruman> <20141122132309.GC2679@katana> <B6D9B4D7-25CB-456F-88B4-EB6A53E33A9D@gmail.com> <20141122180222.GA9698@katana> <20141123044306.GA19898@saruman>
To: balbi@ti.com
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


23 нояб. 2014 г., в 7:43, Felipe Balbi <balbi@ti.com> написал(а):

> maybe there was a typo? I tested on v3.18-rc3 :-)

I do my tests on kernel from angstrom with almost all i2c-omap patches backported from linux/master.
Then I rebased them to wrong (old) kernel version and posted to the list.

Angstrom kernel is from meta-ti layer. It's the same kernel as for arago.
http://arago-project.org/wiki/index.php/Main_Page

I would really like to switch to the recent kernel, but I don't know how good codec engine (CE) is supported on it.
Initially all ti drivers for codec engine was done for 2.6.x kernels and later some of them was ported for 3.2.x.

Felipe, do you know how CE is supported on v3.18-rc3?

Regards,
Alexander.

