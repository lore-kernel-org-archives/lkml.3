Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab3BCHDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 02:03:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:57180 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab3BCHDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 02:03:40 -0500
Date: Sun, 3 Feb 2013 08:05:36 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH 49/62] uio: convert to idr_alloc()
Message-ID: <20130203070536.GA14320@kroah.com>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-50-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359854463-2538-50-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 05:20:50PM -0800, Tejun Heo wrote:
> Convert to the much saner new idr interface.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: "Hans J. Koch" <hjk@hansjkoch.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

