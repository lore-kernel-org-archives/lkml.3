Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaGNIoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:44:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34432 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaGNIoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:44:10 -0400
Date: Mon, 14 Jul 2014 11:43:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lucas Tanure <tanure@linux.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: android: Clean up else statement from
 binder_send_failed_reply
Message-ID: <20140714084358.GJ25880@mwanda>
References: <20140713232513.GA15486@archDesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140713232513.GA15486@archDesk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 08:25:13PM -0300, Lucas Tanure wrote:
> Kernel coding style. Remove useless else statement after return.
> Changes from v1 and v2: Fix warning for mixed declarations and code.
> Declaration of "struct binder_transaction *next" made outside of while,
> and initialized with NULL. 

Don't initialize it at all.  It just disables GCC's builtin warning
for using unitialized variables.

regards,
dan carpenter

