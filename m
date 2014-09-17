Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbaIQQXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:23:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbaIQQXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:23:42 -0400
Date: Wed, 17 Sep 2014 09:22:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Shirish Pargaonkar <spargaonkar@suse.com>,
        Sasha Levin <sasha.levin@oracle.com>, Jet Chen <jet.chen@intel.com>,
        Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 3.14 108/114] blkcg: dont call into policy draining if
 root_blkg is already gone
Message-ID: <20140917162252.GA23586@kroah.com>
References: <20140915192641.428509513@linuxfoundation.org>
 <20140915192644.795711233@linuxfoundation.org>
 <1410952609.3040.100.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410952609.3040.100.camel@decadent.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 12:16:49PM +0100, Ben Hutchings wrote:
> On Mon, 2014-09-15 at 12:26 -0700, Greg Kroah-Hartman wrote:
> > 3.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Tejun Heo <tj@kernel.org>
> > 
> > commit 2a1b4cf2331d92bc009bf94fa02a24604cdaf24c upstream.
> 
> This is a duplicate of commit 0b462c89e31f which was already
> cherry-picked into 3.10.51 and 3.14.15 and included in 3.16-rc7.  You
> can drop it from all the updates.

Ah, thanks, missed that.

greg k-h
