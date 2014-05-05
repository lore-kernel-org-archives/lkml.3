Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaEENbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:31:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbaEENbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:31:38 -0400
Date: Mon, 5 May 2014 06:31:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH] drivercore: fix a corner case for deferred probe
Message-ID: <20140505133137.GA4572@kroah.com>
References: <1398045202-5714-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <20140505022805.GA15162@richard>
 <20140505030432.GA11957@kroah.com>
 <20140505084717.GA5712@richard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505084717.GA5712@richard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 04:47:17PM +0800, Wei Yang wrote:
> On Sun, May 04, 2014 at 08:04:32PM -0700, Greg KH wrote:
> >On Mon, May 05, 2014 at 10:28:05AM +0800, Wei Yang wrote:
> >> Hi, all
> >> 
> >> Anyone has some comment on this?
> >
> >Did you miss the patch from Grant that is now in Linus's tree that
> >should resolve this issue?
> 
> Hi, Greg,
> 
> Nice to hear from you.
> 
> Would you mind telling me the exact tree and commit? I searched in the
> git.kernel.org, and see several Linus's tree, including Linus Torvalds and
> Linus Walleij. So, not sure which you are pointing to. With the exact commit
> and tree, I could take a more deep look into it :-)

Use Linus Torvalds's tree, and look at commit
58b116bce13612e5aa6fcd49ecbd4cf8bb59e835 "drivercore: deferral race
condition fix"

> BTW, I am using this tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> based on commit "455c6fd Linux 3.14".

That is the right tree, but a very old commit, please update your tree.

thanks,

greg k-h
