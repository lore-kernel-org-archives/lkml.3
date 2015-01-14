Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbbANMaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:30:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31982 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbbANMaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:30:23 -0500
Date: Wed, 14 Jan 2015 15:29:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Helene Gsaenger <helene.gsaenger@studium.fau.de>
Cc: devel@driverdev.osuosl.org, simone.weiss@fau.de,
        Michael.Hennerich@analog.com, linux-kernel@i4.cs.fau.de,
        linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, pmeerw@pmeerw.net, knaack.h@gmx.de,
        jic23@kernel.org
Subject: Re: [PATCH] staging/iio/accel: checkpatch: fixed long lines by
 putting comments in seperate lines
Message-ID: <20150114122936.GF5571@mwanda>
References: <20141227072400.GB4780@sudip-PC>
 <1421237890-18422-1-git-send-email-helene.gsaenger@studium.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421237890-18422-1-git-send-email-helene.gsaenger@studium.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 01:18:10PM +0100, Helene Gsaenger wrote:
> +/* Flash memory write count */
> +#define ADIS16203_FLASH_CNT      0x00

Ugh.  No.  That's super ugly.  The original was fine.  Just ignore
checkpatch.pl when it complains about stupid stuff.

regards,
dan carpenter

