Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaAOEGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 23:06:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaAOEG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 23:06:28 -0500
Date: Tue, 14 Jan 2014 20:06:42 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Li Zefan <lizefan@huawei.com>
Cc: stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [STABLE] find missing bug fixes in a stable kernel
Message-ID: <20140115040642.GA16810@kroah.com>
References: <52D3958B.1060902@huawei.com>
 <20140113155746.GA2432@kroah.com>
 <52D494D2.7000908@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D494D2.7000908@huawei.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 09:37:22AM +0800, Li Zefan wrote:
> On 2014/1/13 23:57, Greg Kroah-Hartman wrote:
> > On Mon, Jan 13, 2014 at 03:28:11PM +0800, Li Zefan wrote:
> >> We have several long-term and extended stable kernels, and it's possible
> >> that a bug fix is in some stable versions but is missing in some other
> >> versions, so I've written a script to find out those fixes.
> >>
> >> Take 3.4.xx and 3.2.xx for example. If a bug fix was merged into upstream
> >> kernel after 3.4, and then it was backported to 3.2.xx, then it probably
> >> needs to be backported to 3.4.xx.
> > 
> > I agree.
> > 
> >> The result is, there're ~430 bug fixes in 3.2.xx that probably need to be
> >> backported to 3.4.xx. Given there're about 4500 commits in 3.2.xx, that
> >> is ~10%, which is quite a big number for stable kernels.
> > 
> > That's a really big number, how am I missing so many patches for the 3.4
> > kernel?  Is it because people are doing backports to 3.2 for patches
> > that didn't apply to 3.4?  Or are these patches being applied that do
> > not have -stable markings on them?  Or something else?
> > 
> 
> I guess the biggest reason is, most people tag a patch with stable without
> specifying kernel versions, and if this patch can't be applied to 3.4, it
> will be dropped silently. I guess Ben has been checking this kind of patches
> manually.
> 
> >> We (our team in Huawei) are going to go through the whole list to filter
> >> out fixes that're applicable for 3.4.xx.

Please do this, I don't have the resources at the moment to be able to
go through all of these git ids to see if they really are relevant or
not right now.  Any help that you can provide with this for 3.4 or 3.10
would be most appreciated.

thanks,

greg k-h
