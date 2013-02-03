Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3BCW63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 17:58:29 -0500
Received: from mout.gmx.net ([212.227.17.21]:60712 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab3BCW61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 17:58:27 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19cxWEkZDFcca4GW5hDpV9mfHFz0udBvJT9gKN8m4
	NA8sd73Rpblzbk
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH] TPM: Work around buggy TPMs that block during continue self test
Date: Mon, 4 Feb 2013 00:02:17 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.4; KDE/4.9.3; x86_64; ; )
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Kent Yoder <shpedoikal@gmail.com>, linux-kernel@vger.kernel.org
References: <20121121211529.GA27696@obsidianresearch.com> <CAM0nabE9qORsD1bMDm6EUZogPqb2m-X8rZ-xVqJecM7oJyaciw@mail.gmail.com> <20130125202538.GA16038@obsidianresearch.com>
In-Reply-To: <20130125202538.GA16038@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302040002.17496.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 25. Januar 2013, 21:25:38 schrieb Jason Gunthorpe:
> > https://github.com/shpedoikal/linux.git tpmdd-01-22-13
> 
> Thanks Kent, I will try to test your branch next week, if I am able.
> 
> Can you also grab
> 
> https://github.com/jgunthorpe/linux/commit/98b2a198b43b41b0535200bf47516078
> 6398f114
> 

This one looks good to me.
For this one please add my 
Reviewed-by: Peter Huewe <peterhuewe@gmx.de>

Thanks,
PeterH 
