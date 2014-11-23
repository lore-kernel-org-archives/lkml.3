Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaKWB1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 20:27:19 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34829 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbaKWB1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 20:27:16 -0500
Message-ID: <1416706034.17888.9.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: net: Hyper-V: Deletion of an unnecessary check before the
 function call "vfree"
From: Eric Dumazet <eric.dumazet@gmail.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: David Miller <davem@davemloft.net>, Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Date: Sat, 22 Nov 2014 17:27:14 -0800
In-Reply-To: <54712F8C.10206@users.sourceforge.net>
References: <546DF9D7.6080801@users.sourceforge.net>
		<20141121.151503.1986113223309494197.davem@davemloft.net>
		<546FB98E.5070703@users.sourceforge.net>
	 <20141121.172705.540279259389643572.davem@davemloft.net>
	 <54712F8C.10206@users.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-23 at 01:51 +0100, SF Markus Elfring wrote:
> > This has nothing to do with me asking you to frame your patches
> > against the correct tree.
> 
> I imagine than someone other can also pick up this update suggestion
> (a simple change of two lines) quicker before I might try another
> software build again from a different commit as a base.

I have no idea why someone would do that.

If you don't bother resubmit, nobody will.


