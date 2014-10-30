Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161165AbaJ3Ue2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 16:34:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513AbaJ3Ue2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 16:34:28 -0400
Date: Thu, 30 Oct 2014 13:33:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, markh@compro.net, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH V2] staging: dgap: re-arrange functions for removing
 forward declarations
Message-ID: <20141030203317.GA8137@kroah.com>
References: <20141030031400.GA3312@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030031400.GA3312@devel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:14:00PM +0900, Daeseok Youn wrote:
> Re-arrange the functions for removing forward declarations.
> 
> Tested-by: Mark Hounschell <markh@compro.net>
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> Tested-by: Mark Hounschell <markh@compro.net>
> ---
> V2: this patch is rebased on staging-next branch.

Still doesn't apply :(
