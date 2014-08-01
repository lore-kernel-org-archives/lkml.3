Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaHAIQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:16:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaHAIQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:16:08 -0400
Date: Fri, 1 Aug 2014 01:15:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vincent Bernat <vincent@bernat.im>
Cc: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: visorchipset: fix sparse warnings about static
 declaration
Message-ID: <20140801081537.GA920@kroah.com>
References: <1406880622-12324-1-git-send-email-vincent@bernat.im>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406880622-12324-1-git-send-email-vincent@bernat.im>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 10:10:22AM +0200, Vincent Bernat wrote:
> Some functions were prototyped as static but the actual definition
> wasn't. While this is valid (the function is static because the two
> declarations don't conflict and the first one is static), this makes
> sparse unhappy and cause confusion of normal people too.
> 
> Signed-off-by: Vincent Bernat <vincent@bernat.im>
> ---
>  .../unisys/visorchipset/visorchipset_main.c        | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)

This no longer applies cleanly to my tree, can you please refresh it and
resend so that I can apply it?

thanks,

greg k-h
