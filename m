Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab3D2QZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:25:10 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63724 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084Ab3D2QZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:25:08 -0400
MIME-Version: 1.0
In-Reply-To: <4ece0e3662e670af6982baa43c1d3fd0.squirrel@webmail.iitg.ernet.in>
References: <OFCF117D0B.61A9CA12-ON48257B4F.002F2292-48257B4F.0030E459@zte.com.cn>
	<CAFLxGvxqwpc5fbyGpy9o4qzEfn0i3eocs36TrkX9=SfZ_oT-5w@mail.gmail.com>
	<4ece0e3662e670af6982baa43c1d3fd0.squirrel@webmail.iitg.ernet.in>
Date: Mon, 29 Apr 2013 18:25:06 +0200
Message-ID: <CAFLxGvxMR-fGf2GgK+G5E3LOxQA73XRwqL3vyyPBhmZWyPWHBw@mail.gmail.com>
Subject: Re: Placing ext3 journal on mtd device
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: d.soumyajit@iitg.ernet.in
Cc: wang.bo116@zte.com.cn, liu.dong3@zte.com.cn,
        artem.bityutskiy@linux.intel.com,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, cui.yunfeng@zte.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 6:08 PM,  <d.soumyajit@iitg.ernet.in> wrote:
> Hi,
>
> In Ext3 performance can be improved by placing journal on SSD. I am able
> to place ext3 journal on an external device. Can you please help me
> placing ext3 journal on mtd device.

*very* bad idea.

--
Thanks,
//richard
