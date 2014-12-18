Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaLRDlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 22:41:36 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46766 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaLRDle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 22:41:34 -0500
Message-ID: <54924CEA.3060808@gmail.com>
Date: Thu, 18 Dec 2014 11:41:30 +0800
From: Charles Chiou <ch1102chiou@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: JBottomley@parallels.com, Oliver Neukum <oneukum@suse.de>,
        ed.lin@promise.com, grace.chang@tw.promise.com,
        linus.chen@tw.promise.com, victor.p@promise.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 v3] scsi:stex.c Add reboot support
References: <548FCD81.7030106@gmail.com> <20141217093027.GA13198@infradead.org>
In-Reply-To: <20141217093027.GA13198@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/17/2014 05:30 PM, Christoph Hellwig wrote:
> I'm not going to add a new reboot notifier for a driver.  If you can
> convince the driver model / PM people to pass this information to
> ->shutdown we can add support for this difference, but not in this way.
>
> Can you send me a series that just adds the hardware support for now, so
> we can dash this PM issue out separately?
>

Hi, we need to provide this information to our device.
We face the HW signal issue on various motherboards.
We experiment on many motherboards, and we observe that the restart 
signal is different on different motherboard. If device misses the 
signal, PCI loss or volume disappearance might happen.


To make power management easier, driver provide the shutdown or reboot 
information to the device.

Sorry, I'm not understand what is meaning of "series".
Could you specify what you what me to send you?
Thank you

BRS
Charles



