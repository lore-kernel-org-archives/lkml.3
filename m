Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaJTGtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:49:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbaJTGtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:49:39 -0400
Date: Mon, 20 Oct 2014 14:48:26 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Neil Zhang <zhangwm@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: base: update cpu offline info when do hotplug
Message-ID: <20141020064826.GA4064@kroah.com>
References: <1413775748-22478-1-git-send-email-zhangwm@marvell.com>
 <20141020044340.GA9589@kroah.com>
 <9034CBD80F070943B59700D7F8149ED9024EB81CAF@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9034CBD80F070943B59700D7F8149ED9024EB81CAF@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 11:39:23PM -0700, Neil Zhang wrote:
>> How much noise is this going to cause on a big/little system that
>> constantly hot unplug/plugs processors all of the time?
> 
> Can you explain more what kind of noise will be introduced on a big/little system?

Have you tested this on such a machine?

> As I know IKS on arm will use cpu_suspend way to power down a core.

Are you sure that it also doesn't use that same functionality to drop a
processor to save power?

Why do you need/want this notification?  What are you going to do with
this information that you don't already have?

thanks,

greg k-h
