Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab3BFWYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:24:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43022 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab3BFWYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:24:11 -0500
Date: Thu, 7 Feb 2013 01:23:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: Emil Goode <emilgoode@gmail.com>, lindner_marek@yahoo.de,
        siwu@hrz.tu-chemnitz.de, davem@davemloft.net,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] batman-adv: Remove unused variable
Message-ID: <20130206222357.GK4937@mwanda>
References: <1360168661-16871-1-git-send-email-emilgoode@gmail.com>
 <20130206172234.GB6008@ritirata.org>
 <1360173353.22154.4.camel@debian>
 <20130206195557.GC6008@ritirata.org>
 <1360187945.25903.5.camel@debian>
 <20130206221022.GF6008@ritirata.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206221022.GF6008@ritirata.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 11:10:22PM +0100, Antonio Quartulli wrote:
> Hi Emil, 
> 
> On Wed, Feb 06, 2013 at 10:59:05 +0100, Emil Goode wrote:
> > Hi Antonio,
> > 
> > If it is easier I can keep an eye on when the commit lands in the
> > net-next tree and then resend a modified version of the patch.
> > Or do you want me to resend it now?
> > 
> 
> Well, that commit should be merged in net-next after the next merge window.
> 
> You can resend it now, but be sure to CC Stephen Rothwell
> <sfr@canb.auug.org.au> (the linux-next maintainer) and to clearly state that the
> patch is for linux-next.
> 

It doesn't go through Stephen Rothwell.  It goes through Andrew
Morton and it should be CC'd to Sasha Levin.

regards,
dan carpenter


