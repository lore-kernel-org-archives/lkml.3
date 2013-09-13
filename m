Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab3IMDQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 23:16:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3IMDQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 23:16:49 -0400
Date: Thu, 12 Sep 2013 20:17:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers
 into n_tty_data"
Message-ID: <20130913031700.GB23757@kroah.com>
References: <20130913005133.GA32479@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913005133.GA32479@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 08:51:33AM +0800, Fengguang Wu wrote:
> Hi Peter,
> 
> FYI, we noticed much increased vmap_area_lock contentions since this
> commit:

What does that mean?  What is happening, are we allocating/removing more
memory now?

What type of load were you running that showed this problem?

thanks,

greg k-h
