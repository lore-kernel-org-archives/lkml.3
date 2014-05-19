Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaESJVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:21:36 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24770 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaESJVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:21:35 -0400
Date: Mon, 19 May 2014 12:21:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Matlack <matlackdavid@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        charrer@alacritech.com, linux-kernel@vger.kernel.org, liodot@gmail.com
Subject: Re: [PATCH 2/2] staging: slicoss: remove slic_reg_params struct
Message-ID: <20140519092119.GT15585@mwanda>
References: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
 <1400385604-21086-3-git-send-email-matlackdavid@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400385604-21086-3-git-send-email-matlackdavid@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 09:00:04PM -0700, David Matlack wrote:
> Remove uninitialized struct that is only used to regulate whether
> incorrect eeprom checksums are ignored.
> 

Looking at the patch, this looks like a bugfix but the changelog doesn't
give any clues.

regards,
dan carpenter

