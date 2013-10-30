Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab3J3NZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:25:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab3J3NZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:25:00 -0400
Date: Wed, 30 Oct 2013 06:26:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [char-misc-next 1/8] mei: debugfs: validate dev is not null
Message-ID: <20131030132658.GC30447@kroah.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
 <1382382343-12066-2-git-send-email-tomas.winkler@intel.com>
 <20131029231841.GA30410@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AEFB8F5@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AEFB8F5@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 07:16:07AM +0000, Winkler, Tomas wrote:
> > 
> > On Mon, Oct 21, 2013 at 10:05:36PM +0300, Tomas Winkler wrote:
> > > make static analyzer happy
> > 
> > That's a stupid analyzer.
> > 
> > Sorry, this case can never be true, so don't check for it.  Fix your
> > analyzer.
> > 
> > > and validate dev argument before dereferencing
> > 
> > Again, no need to do so, it's always set properly.
> > 
> > sorry, I can't take this.
> 
> Fair enough, I didn't like that patch myself now I have other confirmation that this is stupid.

This is about the 10th time I have gotten patches that are somehow being
_forced_ by Intel developers to submit, and require me to say they are
stupid and wrong and push back on.

Someone needs to go stop that Intel code analyzer and push back on them
directly, don't rely on me being the one to do this, it only makes me
grumpy and mad when you all make me do your job on this :(

greg k-h
