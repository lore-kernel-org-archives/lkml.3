Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965083AbaE2JUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:20:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37547 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964987AbaE2JUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:20:18 -0400
Date: Thu, 29 May 2014 12:20:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: dgap: unwind on error in dgap_found_board()
Message-ID: <20140529092000.GY15585@mwanda>
References: <20140529091109.GA3792@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529091109.GA3792@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 06:11:09PM +0900, Daeseok Youn wrote:
> Adds a label for "kfree(brd)". And also remove
> a state value as BOARD_FAILED in brd when dgap_do_remap() is failed.
> Because "brd" will free after failure.

Yes.  Perfect.  Eventually BOARD_FAILED will be removed completely.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

