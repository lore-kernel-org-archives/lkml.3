Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaERUdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 16:33:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43485 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaERUdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 16:33:42 -0400
Date: Sun, 18 May 2014 23:33:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Masaru Nomura <massa.nomura@gmail.com>
Cc: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        oleg.drokin@intel.com, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] staging: lustre: lnet: klnds: Fix coding style in
 socklnd.c
Message-ID: <20140518203327.GN15585@mwanda>
References: <1400433557-24985-1-git-send-email-massa.nomura@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400433557-24985-1-git-send-email-massa.nomura@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 06:19:12PM +0100, Masaru Nomura wrote:
> These patches fix warnings below in socklnd.c to meet coding style.
> Also fix some indenting due to changes to keep readability.
> 
> WARNING: space prohibited between function name and open parenthesis '('
> WARNING: line over 80 characters
> 

All five of these do the same thing.  It should just be one patch.

regards,
dan carpenter

