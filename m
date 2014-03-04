Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbaCDJNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:13:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38601 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480AbaCDJNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:13:43 -0500
Date: Tue, 4 Mar 2014 12:13:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Surendra Patil <surendra.tux@gmail.com>
Cc: gregkh@linuxfoundation.org, rupesh.gujare@atmel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging:ozwpan Replaced wrapper functions with
 actual spin lock function
Message-ID: <20140304091322.GU26722@mwanda>
References: <1393919867-15049-1-git-send-email-surendra.tux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393919867-15049-1-git-send-email-surendra.tux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 11:57:47PM -0800, Surendra Patil wrote:
> * Replaced all the spin lock/unlock wrappers from oz_polling_lock_bh()
> and oz_polllin_unlock_bh() with spin_lock_bh(&g_polling_lock) and
> spin_unlock_bh(&g_polling_lock).Completely erased the wrappers defination
> and declaration.
> * declared g_polling_lock as global variable in header file and added comments to it.
> Module builded successfully with sparse without warnings.
> 
> Signed-off-by: Surendra Patil <surendra.tux@gmail.com>

Looks good, thanks.

regards,
dan carpenter

