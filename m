Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaLQODp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:03:45 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27527 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaLQODo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:03:44 -0500
Date: Wed, 17 Dec 2014 17:03:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: samuel kihahu <skihahu@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        speakup@linux-speakup.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: speakup: replace simple_strtoul with kstrtoul
Message-ID: <20141217140322.GM4856@mwanda>
References: <1418817362-29088-1-git-send-email-skihahu@gmail.com>
 <20141217121119.GL4856@mwanda>
 <20141217134354.GA585@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217134354.GA585@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 04:43:54PM +0300, samuel kihahu wrote:
> On Wed, Dec 17, 2014 at 03:11:19PM +0300, Dan Carpenter wrote:
> > On Wed, Dec 17, 2014 at 02:56:02PM +0300, samuel kihahu wrote:
> > > Replacing obsolete simple_strtoul with kstrtoul.
> > > 
> > 
> > Nope.  That's wrong.  Learn how the functions are different beyond just
> > the name.
> Noted, have made corrections to fit the kstrtoul and handle the return
> value.

You have to compile test these things.  Really kernel programming is not
a good way to learn how to program.  :(

regards,
dan carpenter

