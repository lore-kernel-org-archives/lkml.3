Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaETAuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:50:01 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:55404 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaETAuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:50:00 -0400
Date: Mon, 19 May 2014 20:49:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Ron <ron@debian.org>, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH driver-core-linus] sysfs: make sure read buffer is zeroed
Message-ID: <20140520004955.GA30633@mtj.dyndns.org>
References: <20140519172334.GK20439@audi.shelbyville.oz>
 <20140519195210.GA27506@mtj.dyndns.org>
 <20140519222500.GA14616@kroah.com>
 <1400538742.14238.51.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400538742.14238.51.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 03:32:22PM -0700, Joe Perches wrote:
> > > +	memset(buf, 0, PAGE_SIZE);
> 
> 	memset(buf, 0, count)?

It's always PAGE_SIZE.  Outputs longer than that are truncated.

Thanks.

-- 
tejun
