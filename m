Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3DRTLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 15:11:04 -0400
Received: from senator.holtmann.net ([87.106.208.187]:51312 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab3DRTLC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 15:11:02 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [PATCH] net-sysfs: Add entry for nl80211 interface type
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9E05713A@SC-VEXCH1.marvell.com>
Date: Thu, 18 Apr 2013 12:10:59 -0700
Cc: "linux-netdev@vger.kernel.org" <linux-netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Stewart <pstew@chromium.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <CD07F4FD-7136-44EA-A39C-5AB660726BDE@holtmann.org>
References: <1366236369-543-1-git-send-email-bzhao@marvell.com> <0156C538-4175-47E9-B667-C2127CBEF3EB@holtmann.org> <477F20668A386D41ADCC57781B1F70430D9E05713A@SC-VEXCH1.marvell.com>
To: Bing Zhao <bzhao@marvell.com>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bing,

>>> Add a "wireless/nl80211_iftype" entry in the net device sysfs
>>> file structure to indicate the mode of the wireless device so
>>> it can be discovered easily from userspace.
>> 
>> I do question a little bit the usefulness for this one.
>> It would only work on netdev and on wdev devices.
> 
> It's true. That's why the new sysfs entry is added in the 'wireless' placeholder.
> 
> /sys/class/net/ethX/wireless/
> 
> For non-wireless dev, this won't apply.

I have to correct myself. I meant it does NOT work for wdev. Please just go with nl80211 for this kind of information. It is the right way to handle it. Not some sysfs file.

Regards

Marcel

