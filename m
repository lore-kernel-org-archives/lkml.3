Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab3I3UOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:14:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003Ab3I3UO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:14:29 -0400
Date: Mon, 30 Sep 2013 13:14:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCHSET] sysfs: use seq_file and unify regular and bin file
 handling
Message-ID: <20130930201428.GA24348@kroah.com>
References: <1380404984-31858-1-git-send-email-tj@kernel.org>
 <20130928221513.GA20640@htj.dyndns.org>
 <20130930195403.GB8091@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930195403.GB8091@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 03:54:03PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Sat, Sep 28, 2013 at 06:15:13PM -0400, Tejun Heo wrote:
> > On the second thought, 0011 seems too dangerous, especially for pci IO
> > BAR regions.  Grumble, looks like I'll have to break out the bin read
> > path.  Please ignore patches >= 0009.  I'll update them and repost.
> 
> Please ignore the whole series for now.  It seems like we'll need a
> separate read path for the existing sysfs interface anyway and
> seq_file interface should be added separately.  Will post updated
> patches soon.

Ok, consider it ignored :)
