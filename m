Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbaLBQxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:53:38 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:36541 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228AbaLBQxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:53:36 -0500
Message-ID: <1417539208.1841.1.camel@sipsolutions.net>
Subject: Re: net-PA Semi: Deletion of unnecessary checks before the function
 call "pci_dev_put"
From: Johannes Berg <johannes@sipsolutions.net>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Olof Johansson <olof@lixom.net>, netdev@vger.kernel.org,
        backports@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 02 Dec 2014 17:53:28 +0100
In-Reply-To: <alpine.DEB.2.02.1412012134290.2076@localhost6.localdomain6>
References: <5307CAA2.8060406@users.sourceforge.net>
	  <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	  <530A086E.8010901@users.sourceforge.net>
	  <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	  <530A72AA.3000601@users.sourceforge.net>
	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	  <530B5FB6.6010207@users.sourceforge.net>
	  <alpine.DEB.2.10.1402241710370.2074@hadrien>
	  <530C5E18.1020800@users.sourceforge.net>
	  <alpine.DEB.2.10.1402251014170.2080@hadrien>
	  <530CD2C4.4050903@users.sourceforge.net>
	  <alpine.DEB.2.10.1402251840450.7035@hadrien>
	  <530CF8FF.8080600@users.sourceforge.net>
	  <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	  <530DD06F.4090703@users.sourceforge.net>
	  <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	  <5317A59D.4@users.sourceforge.net>
	 <547BC5AD.6090500@users.sourceforge.net>
	  (sfid-20141201_023451_153915_6CFB474F) <1417465745.28610.0.camel@sipsolutions.net>
	 <alpine.DEB.2.02.1412012134290.2076@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 21:34 +0100, Julia Lawall wrote:

> > So this kind of evolution is no problem for the (automated) backports
> > using the backports project - although it can be difficult to detect
> > such a thing is needed.
> 
> That is exactly the problem...

I'm not convinced though that it should stop such progress in mainline.

johannes


