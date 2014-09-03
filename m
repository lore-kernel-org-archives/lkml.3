Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbaICKAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:00:48 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21868 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbaICKAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:00:45 -0400
Date: Wed, 3 Sep 2014 12:59:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sudip Mukherjee <sudip@vectorindia.org>
Cc: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, sparmaintainer@unisys.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] staging: unisys: uislib: uisqueue.c: rewrite of
 do_locked_client_insert
Message-ID: <20140903095950.GF6600@mwanda>
References: <1409736561-23883-1-git-send-email-sudip@vectorindia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409736561-23883-1-git-send-email-sudip@vectorindia.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 02:59:21PM +0530, Sudip Mukherjee wrote:
> 1) removed unused variables
> 2) fixed sparse warning of context imbalance in 'do_locked_client_insert'
>                          different lock contexts for basic block
> 3) removed the call to visor_signalqueue_empty() , this function is
>    checking whether a signal queue is empty, but the return value
>    of the function is not beeing used, so it is safe to remove.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

Looks good.  Thanks!

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter


