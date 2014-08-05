Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbaHEHGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:06:06 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:38281 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006AbaHEHGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:06:01 -0400
Date: Tue, 5 Aug 2014 09:05:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Nick Krause <xerofoify@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Deepak Saxena <dsaxena@linaro.org>,
        "manjunath.goudar" <manjunath.goudar@linaro.org>,
        "jg1.han" <jg1.han@samsung.com>, davidm <davidm@egauge.net>,
        Ksenia Ragiadakou <burzalodowa@gmail.com>,
        hartleys <hartleys@visionengravers.com>,
        "gregory.clement" <gregory.clement@free-electrons.com>,
        oneukum <oneukum@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] xhci: Merge and Update debugging for patches from 3.6
 kernel tree
Message-ID: <20140805070548.GA27941@ravnborg.org>
References: <1407214617-27317-1-git-send-email-xerofoify@gmail.com>
 <20140805054555.GA1920@kroah.com>
 <CAPDOMVg_Y7VgdM0ovcS=w7juBZ4n3xnV+kzbtzTxNZjEKzC3sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVg_Y7VgdM0ovcS=w7juBZ4n3xnV+kzbtzTxNZjEKzC3sA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 01:55:34AM -0400, Nick Krause wrote:
> On Tue, Aug 5, 2014 at 1:45 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, Aug 05, 2014 at 12:56:57AM -0400, Nicholas Krause wrote:
> >> I am adding the fixes to the tree send for adding debugging to the kernel
> >> tree from a patch sent in 2013 on the the 3.6 release. The patch adds
> >> debugging over xhci capable debugging usb ports and needed to be updated
> >> into the latest rc tree. The patch was first sent in this thread,
> >> http://marc.info/?l=linux-usb&m=135948845511047.
> >>
> >> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> >
> You haven't even checked my patch, our you just going to assume it's wrong?

If you spend 20 seconds reding what I quouted above you will find
bugs already.

1) No proper attribution
2) No proper description of the purpose of the patch

And considering the history of your formar patches
3) No documentation on how the patch was verified


There is no need to read the code with so many bugs in the changelog already.

	Sam
