Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334Ab3EaFiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 01:38:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55741 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750784Ab3EaFiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 01:38:00 -0400
Message-ID: <1369978679.10556.36.camel@joe-AO722>
Subject: Re: [PATCH 0/3] pktcdvd: A few more neatenings
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Date: Thu, 30 May 2013 22:37:59 -0700
In-Reply-To: <cover.1369947186.git.joe@perches.com>
References: <alpine.LNX.2.00.1305291537120.30576@pobox.suse.cz>
	 <cover.1369947186.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-30 at 13:57 -0700, Joe Perches wrote:
> Joe Perches (3):
>   pktcdvd: Convert ZONE macro to static function get_zone()
>   pktcdvd: Convert printk to pr_<level>
>   pktcdvd: Consolidate DPRINTK and VPRINTK macros
> 
>  drivers/block/pktcdvd.c | 248 ++++++++++++++++++++++++------------------------
>  1 file changed, 126 insertions(+), 122 deletions(-)
> 

Hey Jiri.

This doesn't compile correctly.
1/3 adds a compile time error, 2/3 corrects it.

Please ignore it.

