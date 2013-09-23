Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3IWN3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:29:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32202 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3IWN3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:29:07 -0400
Date: Mon, 23 Sep 2013 16:29:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: checkpatch guide for newbies
Message-ID: <20130923132901.GH6247@mwanda>
References: <20130923090100.GE6192@mwanda>
 <CA+MoWDpwx_2kh9bEARh4D5xzyYhWekAceipf0YN=3a+Q5W4eNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+MoWDpwx_2kh9bEARh4D5xzyYhWekAceipf0YN=3a+Q5W4eNQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 02:46:38PM +0200, Peter Senna Tschudin wrote:
> > It's preferred if the operator goes at the end of the first line instead of at
> > the start of the second line:
> > Bad:
> > -       PowerData = (1 << 31) | (0 << 30) | (24 << 24)
> > -                   | BitReverse(w89rf242_txvga_data[i][0], 24);
> > Good:
> > +       PowerData = (1 << 31) | (0 << 30) | (24 << 24) |
> > +                   BitReverse(w89rf242_txvga_data[i][0], 24);
> What is the rule for where to start the second line here?
> 

The if statement alignment has become a rule and people will make you
redo it if it's not aligned.  I haven't seen anyone have to redo a
patch because of alignment on these:

My favorite format is aligned:
	foo = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -
	      yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy;

Also popular:
	foo = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -
		yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy;

Right aligned looks like nonsense:
	foo = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -
					yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy;

Here is a more complex aligned statement:
	foo = bar * (xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -
		     yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy);

regards,
dan carpenter
