Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaJBQb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:31:57 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40933 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbaJBQbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:31:55 -0400
X-Sasl-enc: vzgi5l5wbTzJKmO/ScXUIO0sRQ4q61aJewnrFAXYt2za 1412267510
Date: Thu, 2 Oct 2014 09:31:49 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tapasweni Pathak <tapaswenipathak@gmail.com>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20141002163149.GA1056@kroah.com>
References: <20140930180416.5ae64587@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930180416.5ae64587@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 06:04:16PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/staging/media/cxd2099/cxd2099.c: In function 'slot_reset':
> drivers/staging/media/cxd2099/cxd2099.c:537:4: error: expected ';' before 'if'
>     if (ci->ready)
>     ^
> 
> Caused by commit 7b86477c0e5b ("staging: media: cxd2099: use
> usleep_range()").
> 
> I have reverted that commit for today.

Now fixed, thanks.

greg k-h
