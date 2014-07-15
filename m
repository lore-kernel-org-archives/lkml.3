Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbaGOGld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 02:41:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39148 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279AbaGOGlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 02:41:31 -0400
Date: Tue, 15 Jul 2014 09:41:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] staging: dgap: introduce dgap_cleanup_nodes()
Message-ID: <20140715064125.GQ25880@mwanda>
References: <20140715030402.GA14411@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715030402.GA14411@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 12:04:02PM +0900, Daeseok Youn wrote:
> When a configration file is parsed with dgap_parsefile(),
> makes nodes for saving configrations for board.
> 
> Making a node will allocate node memory and strings for saving
> configrations with kstrdup().
> 
> So these are freed when dgap is unloaded or failed to initialize.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> It MUST be needed to prevent memory leaks but
> I'm not sure that I fix properly.
> 
> Please review.

This thread doesn't have Mark on the CC list and he's the only person
who can actually test it properly.  Resend it and CC Mark
Hounschell <markh@compro.net>.

regards,
dan carpenter

