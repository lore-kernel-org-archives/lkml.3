Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab3DVP6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 11:58:12 -0400
Received: from longford.logfs.org ([213.229.74.203]:58881 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3DVP6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 11:58:11 -0400
Date: Mon, 22 Apr 2013 10:31:18 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Joe Perches <joe@perches.com>
Cc: Joern Engel <joern@lazybastard.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: Convert logging messages
Message-ID: <20130422143118.GA12908@logfs.org>
References: <1366394375.3901.36.camel@joe-AO722>
 <20130419165516.GA19480@logfs.org>
 <1366396053.3901.40.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366396053.3901.40.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 April 2013 11:27:33 -0700, Joe Perches wrote:
> On Fri, 2013-04-19 at 12:55 -0400, Jörn Engel wrote:
> > On Fri, 19 April 2013 10:59:35 -0700, Joe Perches wrote:
> > >  	}
> > >  	list_add(&dev->list, &blkmtd_device_list);
> > > -	INFO("mtd%d: [%s] erase_size = %dKiB [%d]", dev->mtd.index,
> > > -			dev->mtd.name + strlen("block2mtd: "),
> > > -			dev->mtd.erasesize >> 10, dev->mtd.erasesize);
> > > +	pr_info("mtd%d: [%s] erase_size = %dKiB [%d]\n",
> > > +		dev->mtd.index,
> > > +		dev->mtd.name + strlen("block2mtd: "),
> > > +		dev->mtd.erasesize >> 10, dev->mtd.erasesize);
> > 
> > I personally dislike the indent-to-braces style because it causes
> > unnecessary churn in patches like this.
> 
> It comes from an automated emacs conversion.

Then please teach your emacs to be a better tool.  I trust you are
smart enough to do that.

Jörn

--
He who knows that enough is enough will always have enough.
-- Lao Tsu
