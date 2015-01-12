Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbbAMA5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 19:57:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbbAMA5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 19:57:38 -0500
Date: Mon, 12 Jan 2015 15:03:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Milkovich <amilkovich@gmail.com>
Cc: benjamin.romer@unisys.com, david.kershner@unisys.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: unisys: virtpci: fixed coding style errors
Message-ID: <20150112230321.GA22984@kroah.com>
References: <1418865910-21337-1-git-send-email-amilkovich@gmail.com>
 <20150110014123.GA30739@kroah.com>
 <20150112225353.GA22382@zenbook.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112225353.GA22382@zenbook.hsd1.ca.comcast.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 02:53:53PM -0800, Andrew Milkovich wrote:
> Hi,
> 
> On Fri, Jan 09, 2015 at 05:41:23PM -0800, Greg KH wrote:
> > On Wed, Dec 17, 2014 at 05:25:10PM -0800, Andrew Milkovich wrote:
> > > Fixed coding style errors per checkpatch.pl. Inline comments removed.
> > 
> > What coding errors did you fix?  Please be specific.
> 
> Some inline comments were removed. Some talked about chanptr, which is known
> because the first argument is the chan.
> 
> The other comments talked about no parent bus, but NULL signifies that there is
> no parent bus.

I was trying to hint that this needs to be in the changelog entry...
