Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab3IAW7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 18:59:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31358 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab3IAW7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 18:59:18 -0400
Date: Mon, 2 Sep 2013 01:58:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Forest Bond <forest@alittletooquiet.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [staging] Staging: Convert uses of compare_ether_addr to
 ether_addr_equal
Message-ID: <20130901225851.GW6329@mwanda>
References: <522395c4.hZ2B3PrpTjC+j1oP%wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522395c4.hZ2B3PrpTjC+j1oP%wangshilong1991@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 03:30:12AM +0800, Wang Shilong wrote:
> Hello, Using checkpatch.pl, i get the following warnings(errors):

All of these were there in the original code.

Have your script copy the messages to your postponed messages folder and
then look over the output before mailing it.

regards,
dan carpenter

