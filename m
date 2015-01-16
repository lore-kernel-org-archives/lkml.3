Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbbAPKUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:20:40 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22898 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbbAPKUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:20:39 -0500
Date: Fri, 16 Jan 2015 13:20:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, dsd@laptop.org,
        jfrederich@gmail.com, gregkh@linuxfoundation.org,
        jon.nettleton@gmail.com
Subject: Re: [PATCH 1/2] staging: olpc_dcon: check for CONFIG_OLPC before
 calling olpc_board_at_least()
Message-ID: <20150116102029.GE6201@mwanda>
References: <1421373300-13672-1-git-send-email-mopsfelder@gmail.com>
 <1421373300-13672-2-git-send-email-mopsfelder@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421373300-13672-2-git-send-email-mopsfelder@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 11:54:59PM -0200, Murilo Opsfelder Araujo wrote:
> The following error messages are thrown by sparse when CONFIG_OLPC is
> not defined:
> 
> drivers/staging/olpc_dcon/olpc_dcon.c:147:17: error: undefined identifier 'olpc_board_at_least'
> drivers/staging/olpc_dcon/olpc_dcon.c:208:14: error: undefined identifier 'olpc_board_at_least'
> 
> This patch fixes these errors.

Don't add ifdefs to a .c file.  Don't call BUG_ON() in a driver.

Figure out a better way to fix these.

regards,
dan carpenter

