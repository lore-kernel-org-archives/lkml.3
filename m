Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab3EBWAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 18:00:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39121 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab3EBWAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 18:00:46 -0400
Date: Fri, 3 May 2013 01:00:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] configfs: use capped length for ->store_attribute()
Message-ID: <20130502220034.GP5123@mwanda>
References: <20130430072813.GC7237@elgon.mountain>
 <20130502215152.GB26770@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502215152.GB26770@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 02:51:53PM -0700, Joel Becker wrote:
> On Tue, Apr 30, 2013 at 10:28:14AM +0300, Dan Carpenter wrote:
> > The difference between "count" and "len" is that "len" is capped at
> > 4095.  Changing it like this makes it match how sysfs_write_file() is
> > implemented.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Acked-by: Joel Becker <jlbec@evilplan.org>
> 
> Do you want me to push this up, or will you be sending it?

Could you push it?

regards,
dan carpenter


