Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbaGXLDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:03:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:20350 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaGXLDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:03:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,723,1400050800"; 
   d="scan'208";a="574742508"
Message-ID: <53D0E7E9.5090608@intel.com>
Date: Thu, 24 Jul 2014 19:03:05 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Peter Hurley <peter@hurleysoftware.com>,
        Greg KH <gregkh@linuxfoundation.org>, mnipxh <mnipxh@gmail.com>,
        jslaby@suse.cz, linux-kernel@vger.kernel.org,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] tty/tty_io.c: make a check before reuse cdev
References: <53CD0BD4.4050007@gmail.com>	<20140721153840.GA6802@kroah.com>	<53CE5097.2000502@intel.com>	<53CE941B.1030102@hurleysoftware.com>	<53CF7EAC.8010201@intel.com> <20140723170753.5e2047c5@alan.etchedpixels.co.uk>
In-Reply-To: <20140723170753.5e2047c5@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014年07月24日 00:07, One Thousand Gnomes 写道:
>> Very nice solution. We will check if this can cause any risk, both to kernel and user space.
>> Using a new tty base to register with new cdevs may give us more chance to wait PROCESS quit/close.
>> when total 256 tty used up, what we should do is still in discuss.
> 
> At that point you may want to look at how fuser works and create some
> kind of policy manager needs to kill problem tasks owning a device.
> 
> Or in theory there is no reason nowdays we can't go above 256 devices -
> in theory 8)
> 

hi, Alan
	Thanks for your nice comments.
In theory it can go over 256 devices, In fact, it will waste more memories. :)
We really need a policy manager that works well.
FT guys may offer it one day. it's a little long time maybe. :(

When I was a student, I heard you left from kernel.
Welcome back to kernel, I didn't know that you are back. So sorry.

thanks,

xinhui

> Alan
> 
> 
