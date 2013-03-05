Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3CEVyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:54:45 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49202 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3CEVyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:54:43 -0500
Date: Tue, 5 Mar 2013 16:54:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, dan.magenheimer@oracle.com
Subject: Re: [PATCH 05/11] zcache: Make the debug code use pr_debug
Message-ID: <20130305215430.GB18408@phenom.dumpdata.com>
References: <1362421101-15896-1-git-send-email-konrad.wilk@oracle.com>
 <1362421101-15896-6-git-send-email-konrad.wilk@oracle.com>
 <1362421733.1965.11.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362421733.1965.11.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 10:28:53AM -0800, Joe Perches wrote:
> On Mon, 2013-03-04 at 13:18 -0500, Konrad Rzeszutek Wilk wrote:
> > as if you are debugging this driver you would be using 'debug'
> > on the command line anyhow - and this would dump the debug
> > data on the proper loglevel.
> 
> Please add
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> before any #includes and remove all the "zcache: "
> prefixes from the pr_<level> uses.
> 
> 
> > +	pr_debug("zcache: obj_count=%zd\n", zcache_obj_count);
> 
> just pr_debug("obj_count=%zd\n", zcache_obj_count);

Sure. Let me spin out another patch for this.
