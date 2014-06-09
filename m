Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944AbaFIKws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:52:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49063 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932201AbaFIKwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:52:45 -0400
Date: Mon, 9 Jun 2014 12:52:42 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jisheng Zhang <jszhang@marvell.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] usb: phy: add the Berlin USB PHY driver
Message-ID: <20140609105241.GC3112@piout.net>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
 <1401983326-19205-5-git-send-email-antoine.tenart@free-electrons.com>
 <53919DCE.1050708@gmail.com>
 <20140609162631.76bd2ad7@xhacker>
 <5395886D.9090606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5395886D.9090606@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2014 at 12:11:57 +0200, Sebastian Hesselbarth wrote :
> > Some BG2Q boards hardwired the vbus to be always powered on, we should continue
> > the probe if vbus gpio is missing.
> 
> Yeah, the same applies for regulators. But with the comments above, it
> should move to the controller stub instead.
> 

We should use a regulator and in the case it is hardwired, use a fixed
regulator. Then, we can stop if it is missing.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
