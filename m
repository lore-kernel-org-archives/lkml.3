Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3DWSAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:00:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60116 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756714Ab3DWR77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:59:59 -0400
Message-ID: <1366739994.2036.1.camel@joe-AO722>
Subject: Re: [PATCH] mtd: Convert logging messages
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Joern Engel <joern@lazybastard.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 23 Apr 2013 10:59:54 -0700
In-Reply-To: <20130422143118.GA12908@logfs.org>
References: <1366394375.3901.36.camel@joe-AO722>
	 <20130419165516.GA19480@logfs.org> <1366396053.3901.40.camel@joe-AO722>
	 <20130422143118.GA12908@logfs.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-22 at 10:31 -0400, Jörn Engel wrote:
> On Fri, 19 April 2013 11:27:33 -0700, Joe Perches wrote:
> > On Fri, 2013-04-19 at 12:55 -0400, Jörn Engel wrote:
> > > On Fri, 19 April 2013 10:59:35 -0700, Joe Perches wrote:
> > > >  	}
> > > >  	list_add(&dev->list, &blkmtd_device_list);
> > > > -	INFO("mtd%d: [%s] erase_size = %dKiB [%d]", dev->mtd.index,
> > > > -			dev->mtd.name + strlen("block2mtd: "),
> > > > -			dev->mtd.erasesize >> 10, dev->mtd.erasesize);
> > > > +	pr_info("mtd%d: [%s] erase_size = %dKiB [%d]\n",
> > > > +		dev->mtd.index,
> > > > +		dev->mtd.name + strlen("block2mtd: "),
> > > > +		dev->mtd.erasesize >> 10, dev->mtd.erasesize);
> > > 
> > > I personally dislike the indent-to-braces style because it causes
> > > unnecessary churn in patches like this.
> > 
> > It comes from an automated emacs conversion.
> 
> Then please teach your emacs to be a better tool.

Because you personally dislike something isn't
enough of a reason for me to change my tools nor
enough of a reason for me to add a special
exception to my tools for your preferences.

> I trust you are smart enough to do that.

Snide much?

cheers, Joe

