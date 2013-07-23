Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab3GWAxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:53:34 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:32787 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753018Ab3GWAxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:53:33 -0400
Message-ID: <1374540811.2061.87.camel@joe-AO722>
Subject: Re: [PATCH V3 0/8] pktcdvd: More neatenings
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Jul 2013 17:53:31 -0700
In-Reply-To: <cover.1370276576.git.joe@perches.com>
References: <20130603125057.GB23987@mwanda>
	 <cover.1370276576.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 09:45 -0700, Joe Perches wrote:
> Thanks for the oversight reviews guys.
> 
> V3:
> Fixed patch 2 thinko in sense_string via Dan Carpenter
> Moved pr_err in patch 5 to avoid moving again in patch 6 via Andy Schevchenko
> 
> V2:
> Removed the compile error the patch 1 and compile fix in 2
> Added Andy's suggestion in patch 2.
> Added conversions to print pd->name in logging macros.
> 
> Joe Perches (8):
>   pktcdvd: Convert ZONE macro to static function get_zone()
>   pktcdvd: Convert printk to pr_<level>
>   pktcdvd: Consolidate DPRINTK and VPRINTK macros
>   pktcdvd: Add struct pktcdvd_device * to pkt_dbg
>   pktcdvd: Add struct pktcdvd_device.name to pr_err logging where possible
>   pktcdvd: Convert pr_notice to pkt_notice
>   pktcdvd: Convert pr_info to pkt_info
>   pktcdvd: Add struct pktcdvd_device * to pkt_dump_sense()
> 
>  drivers/block/pktcdvd.c | 278 ++++++++++++++++++++++++------------------------
>  1 file changed, 140 insertions(+), 138 deletions(-)

Ping?

Jiri, are you doing to do anything with this?


