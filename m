Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab3GZJTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:19:39 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:45561 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758272Ab3GZJTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:19:36 -0400
Date: Fri, 26 Jul 2013 11:19:20 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/36] PTP: convert class code to use dev_groups
Message-ID: <20130726091919.GA7707@netboy>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
 <1374703539-9705-18-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374703539-9705-18-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 03:05:20PM -0700, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the ptp class code to use the
> correct field.
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> Richard, feel free to take this through your tree, or ACK it and I can take it
> through mine.

Please take this through your tree, as the PHC stuff has no tree of
its own, apart from the networking tree. I did also test this patch
briefly.

Acked-by: Richard Cochran <richardcochran@gmail.com>
