Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbaDXL71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:59:27 -0400
Received: from mout.gmx.net ([212.227.17.21]:55874 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbaDXL7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:59:19 -0400
Date: Thu, 24 Apr 2014 13:59:10 +0200
From: Marc Dietrich <marvin24@gmx.de>
To: jaegeuk.kim@samsung.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: f2fs causes system stall
Message-Id: <20140424135910.f095d63eafdf136cc8851114@gmx.de>
In-Reply-To: <1398297270.4283.19.camel@kjgkr>
References: <2601952.jk1l5iHOJT@ax5200p>
	<1398297270.4283.19.camel@kjgkr>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:xcI3iKY8U4Mx6VrgawiH4AAQ8SiOtgEVLkCPsJ111Vf8B1zRsd4
 JLtNDFNvjXYznwUa5qaM8kGW7R0F0ya/jHw5YWKTD42Bh0E3q6G0/dMTzsBd0WAAjqS6eT5
 xp9n5ltHv+2/2CVdM+2PB2Efk+S3Qx1l30SJI3LLiaaXhP6CUEwjOQTuip+b9SqTi81+ViO
 uZ8nAPiHcUi5oHtcZvBXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 24 Apr 2014 08:54:30 +0900
Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:
> Thank you for the report.
> When I veiwed the patch at a glance, it seems that reverting is not a
> good way.
> 
> Instead, could you share the f2fs commit point that you're using?
> Then, since I have a suspect for this issue, I'd like to write a patch
> to test.

patch against linus master is ok for me. I'm happy to test your patch.

> 2014-04-24 (목), 00:00 +0200, Marc Dietrich:
> > Hi,
> > 
> > it took me a while to bisect a problem which causes my ARM (tegra2) netbook to 
> > frequently stall for 5-10 seconds when I enable EXA acceleration (opentegra 
> > experimental ddx). I can only guess that the offending commit 8618b88 "f2fs: 
> > fix not to write data pages on the page reclaiming path" somehow causes high 
> > kernel latencies which may interrupt/disturb the command stream to the gpu in 
> > this particular case. Reverting this commit fixes the problem. Any hints?

Regards,

Marc
