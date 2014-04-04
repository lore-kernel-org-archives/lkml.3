Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaDDN11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 09:27:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22774 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaDDN10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:27:26 -0400
Date: Fri, 4 Apr 2014 16:26:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kumar Amit Mehta <gmate.amit@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, abbotti@mev.co.uk,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: pcl812.c: fixed a coding style
 issue
Message-ID: <20140404132651.GV6991@mwanda>
References: <1396605929-10514-1-git-send-email-gmate.amit@gmail.com>
 <20140404110707.GT6991@mwanda>
 <20140404114852.GA12452@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140404114852.GA12452@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 02:48:52PM +0300, Kumar Amit Mehta wrote:
> On Fri, Apr 04, 2014 at 02:07:07PM +0300, Dan Carpenter wrote:
> > On Fri, Apr 04, 2014 at 01:05:29PM +0300, Kumar Amit Mehta wrote:
> > > Fixed a coding style issue. Reported by checkpatch.pl
> > > 
> > 
> > It's better if the commit messages are more specific than this.
> 
> So, should I resend the patch with a more appropriate commit message ?

[PATCH] staging: comedi: drivers: pcl812.c: add curly braces for checkpatch

Kernel style is that if one side of the if else statement gets has curly
braces then both side should have them.

regards,
dan carpenter

