Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaGNIWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:22:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50839 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaGNIW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:22:28 -0400
Date: Mon, 14 Jul 2014 11:22:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lucas Tanure <tanure@linux.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: Clean up binder_send_failed_reply
Message-ID: <20140714082215.GI25880@mwanda>
References: <20140713140834.GA5387@archDesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140713140834.GA5387@archDesk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 11:08:34AM -0300, Lucas Tanure wrote:
> Kernel coding style. Remove useless else statement after return.
> 

You introduce a GCC warning.

drivers/staging/android/binder.c: In function ‘binder_send_failed_reply’:
drivers/staging/android/binder.c:1217:3: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]

regards,
dan carpenter

