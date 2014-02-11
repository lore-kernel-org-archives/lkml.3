Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbaBKVMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:12:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31984 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbaBKVMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:12:39 -0500
Date: Wed, 12 Feb 2014 00:12:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Fries <David@Fries.net>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] w1: small type cleanup in sysfs
Message-ID: <20140211211228.GY26722@mwanda>
References: <20140211160826.GD9406@elgon.mountain>
 <20140211164513.GF5530@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211164513.GF5530@spacedout.fries.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 10:45:13AM -0600, David Fries wrote:
> Dan,
> 
> I have some other changes in work, how automated is your checkers?
> How much work is it for me to give a github repository and branch and
> find out if I introduced any problems before submitting them?
> 

This is a Smatch thing I'm working on but haven't pushed yet.
Eventually it will be a part of Fengguang Wu's automated kbuild zero
day testing process.

> 
> I didn't get how you could get a less than one after a check for less
> than one from the description or patch until I looked at the rest of
> the source code.  Looks good if the description mentions
> max_slave_count is an int.
> 
> How about wording it,
> 
> On 64 bit systems, a large value for "long tmp" is truncated when
> assigning to "int md->max_slave_count" so we still end up with a value
> less than one despite the "tmp < 1" check.
> 

Sure.  That's clearer.  I have resent it.

regards,
dan carpenter

