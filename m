Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbaIDVjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:39:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbaIDVjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:39:06 -0400
Date: Thu, 4 Sep 2014 14:38:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreea Bernat <bernat.ada@gmail.com>
Cc: Larry.Finger@lwfinger.net, Elena Oat <oat.elena@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] rtl8188eu: Replace rcu_dereference() with
 rcu_access_pointer()
Message-ID: <20140904213821.GB356@kroah.com>
References: <20140817114336.GA24984@ada>
 <20140830204246.GA16563@kroah.com>
 <CALDM6bpomcGJk1Ut2hb8qO0gYeKkHruJZ0duBwAaonFf6HbZwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALDM6bpomcGJk1Ut2hb8qO0gYeKkHruJZ0duBwAaonFf6HbZwA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 11:58:36PM +0300, Andreea Bernat wrote:
> Hello,
> 
> I cloned this:
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> 
> and after moved to staging-next branch, but in both cases, in
> those files I don't find any use of rcu_dereference() call (the call
> which I am looking for to modify).

Then there's nothing left to be done here, right?  :)

thanks,

greg k-h
