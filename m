Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab3BDRlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:41:31 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:43777 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab3BDRla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:41:30 -0500
Message-ID: <1359999624.17993.21.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 59/62] mac80211: convert to idr_alloc()
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2013 18:40:24 +0100
In-Reply-To: <1359854463-2538-60-git-send-email-tj@kernel.org> (sfid-20130203_022315_953264_CAD212B7)
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
	 <1359854463-2538-60-git-send-email-tj@kernel.org>
	 (sfid-20130203_022315_953264_CAD212B7)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-02 at 17:21 -0800, Tejun Heo wrote:
> Convert to the much saner new idr interface.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: linux-wireless@vger.kernel.org
> ---
> This patch depends on an earlier idr changes and I think it would be
> best to route these together through -mm.  Please holler if there's
> any objection.  Thanks.

Looks fine to me, thanks.

johannes


