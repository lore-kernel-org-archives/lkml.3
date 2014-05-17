Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaEQVYI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 17:24:08 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37300 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaEQVYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 17:24:06 -0400
Date: Sun, 18 May 2014 00:23:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Masaru Nomura <massa.nomura@gmail.com>
Cc: devel@driverdev.osuosl.org, Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 3/4] staging: dgnc: dgnc_neo: Fix conditional part of if
 statement
Message-ID: <20140517212353.GH15585@mwanda>
References: <1400344254-13007-1-git-send-email-massa.nomura@gmail.com>
 <1400344254-13007-4-git-send-email-massa.nomura@gmail.com>
 <20140517193927.GD15585@mwanda>
 <CAAvxhqB0ACdZy3q6zbAd-JAtxSSojPYyQq3ZKTfdyisN+e5HjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAvxhqB0ACdZy3q6zbAd-JAtxSSojPYyQq3ZKTfdyisN+e5HjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 10:14:52PM +0100, Masaru Nomura wrote:
> > Also just fold this patch and [patch 2/4] together into one patch.  We
> > don't need two patches to fix one if statement.
> >
> > The one thing per patch rule is a bit tricky.  It means that you have to
> > say which one thing you are fixing.  Don't say "I am fixing three
> > things."  Say "I am fixing one if statement".
> 
> So in this case, do you think I could fold all four patches into one?

No.  That would be more than one thing per patch.  It looks like this:

[patch 1/3] staging: dgnc: dgnc_neo: put else statements on the right line
[patch 2/3] staging: dgnc: dgnc_neo: clean up ugly one very ugly condition
[patch 3/3] staging: dgnc: dgnc_neo: remove extra curly braces

Each patch does one thing.  Cleaning up the whole file is too big so it
doesn't count as doing one thing only.

> As I just worked on the 'same' if statements and divided them into
> four patches, this could be the case. (but I'm not sure yet...)
> 
> Also, should I put v[number] for the modified patches?
> Say [PATCH v2] staging: ...

Yes.

regards,
dan carpenter

