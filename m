Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbbAILbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:31:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119AbbAILbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:31:43 -0500
Message-ID: <1420803092.13007.9.camel@linux-0dmf.site>
Subject: Re: [PATCH 0/2] INPUT/HID: add touch support for SiS touch driver
From: Oliver Neukum <oneukum@suse.de>
To: =?UTF-8?Q?=E6=9B=BE=E5=A9=B7=E8=91=B3?= "(tammy_tseng)" 
	<tammy_tseng@sis.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        tammy0524@gmail.com
Date: Fri, 09 Jan 2015 12:31:32 +0100
In-Reply-To: <8322374EB97AA24A95D0DDBFC8F1CA1DBF96E8@SISMBEV01.sis.com.tw>
References: <8322374EB97AA24A95D0DDBFC8F1CA1DBF96E8@SISMBEV01.sis.com.tw>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 18:36 +0800, 曾婷葳 (tammy_tseng) wrote:
> Signed-off-by: Tammy Tseng <tammy_tseng@sis.com>
> 
> ---
> The patch for i2c multitouch driver in input/touchscreen:
> 
> linux-3.18.1/drivers/input/touchscreen/Kconfig   |   14 -
>  linux-3.18.1/drivers/input/touchscreen/Makefile  |    4 -
>  linux-3.18.1/drivers/input/touchscreen/sis_i2c.c | 1725
> ----------------------
>  linux-3.18.1/drivers/input/touchscreen/sis_i2c.h |  229 ---
>  4 files changed, 1972 deletions(-)

Only deletions and it adds support?
I guess you mixed up your trees.

	Regards
		Oliver



