Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab3D2Qlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:41:39 -0400
Received: from bornadi.iitg.ernet.in ([202.141.80.53]:53404 "EHLO
	bornadi.iitg.ernet.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab3D2Qlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:41:37 -0400
X-Greylist: delayed 1883 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2013 12:41:36 EDT
Message-ID: <4ece0e3662e670af6982baa43c1d3fd0.squirrel@webmail.iitg.ernet.in>
In-Reply-To: <CAFLxGvxqwpc5fbyGpy9o4qzEfn0i3eocs36TrkX9=SfZ_oT-5w@mail.gmail.com>
References: <OFCF117D0B.61A9CA12-ON48257B4F.002F2292-48257B4F.0030E459@zte.com.cn>
    <CAFLxGvxqwpc5fbyGpy9o4qzEfn0i3eocs36TrkX9=SfZ_oT-5w@mail.gmail.com>
Date: Mon, 29 Apr 2013 21:38:54 +0530
Subject: Placing ext3 journal on mtd device
From: d.soumyajit@iitg.ernet.in
To: "richard -rw- weinberger" <richard.weinberger@gmail.com>
Cc: wang.bo116@zte.com.cn, liu.dong3@zte.com.cn,
        artem.bityutskiy@linux.intel.com,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "LKML" <linux-kernel@vger.kernel.org>, cui.yunfeng@zte.com.cn
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In Ext3 performance can be improved by placing journal on SSD. I am able
to place ext3 journal on an external device. Can you please help me
placing ext3 journal on mtd device.

Thanks in Advance!

Soumyajit

