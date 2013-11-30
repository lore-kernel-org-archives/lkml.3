Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab3K3JPl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 04:15:41 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57081 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3K3JPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 04:15:36 -0500
Date: Sat, 30 Nov 2013 18:15:31 +0900
From: =?utf-8?B?SsOpcsO0bWU=?= Pinot <ngc891@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Update: Evolution of the Linux kernel source code tarball size
Message-ID: <20131130091531.GA21999@star.deepsky.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2 years ago, I published a graph showing the evolution of the size of
the linux kernel tar.bz2 against release count:
http://lkml.org/lkml/2011/11/10/267 

I just updated the data and draw the graph. There are now 308 releases
(without the 2.6.x.y and the 3.x.y). I predicted last time that 3.19
would break the 100MB symbolic size and it's been confirmed by the new
data.

You can get the graph on my blog, I provide the data and the gnuplot
batch file for graphing/fitting:
http://ngc891.blogdns.net/?p=339 

Regards,

-- 
Jérôme Pinot
http://ngc891.blogdns.net/
