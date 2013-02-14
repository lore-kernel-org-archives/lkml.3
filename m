Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934770Ab3BNQ7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:59:24 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:45022 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934337Ab3BNQ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:59:23 -0500
Date: Thu, 14 Feb 2013 08:59:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
Subject: Re: [PATCH] Various cleanups/fixes to zcache (v3).
Message-ID: <20130214165920.GA26615@kroah.com>
References: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
 <56c69426-968a-4d0b-a254-dd03456e30d3@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56c69426-968a-4d0b-a254-dd03456e30d3@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 08:56:01AM -0800, Dan Magenheimer wrote:
> > From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> > Subject: [PATCH] Various cleanups/fixes to zcache (v3).
> > 
> > From Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> # This line is ignored.
> > From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Subject: [PATCH] Various cleanups/fixes to zcache (v3).
> > In-Reply-To:
> > 
> > Hey Greg,
> > 
> > These patches do various cleanups of the zcache driver. The majority of the
> > work is just to move all the different counters out to a debug file. The next
> > step would be to figure out which ones are actually pertient and which can
> > go under the knife. Oh, and also fix some of the compiler warnings.
> > 
> > This is based on top of ommit 76426daf50d5df38893cc189e9ccd026093debc8
> > ("staging/zcache: Fix/improve zcache writeback code, tie to a config option")
> > so should apply cleanly to your tree.
> > 
> > Please apply.
> 
> Useful cleanups.
> 
> Hopefully not too late for 3.9-rc0.

You all did see my "the staging tree is closed except for bugfixes for
3.9" message last week, right?

Sorry, this will have to wait for 3.10.

greg k-h
