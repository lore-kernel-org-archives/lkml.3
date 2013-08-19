Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab3HSWVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:21:31 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58399 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab3HSWVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:21:30 -0400
Date: Mon, 19 Aug 2013 17:21:29 -0500
From: Ben Myers <bpm@sgi.com>
To: Richard Weinberger <richard@nod.at>
Cc: xfs@oss.sgi.com, elder@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Register hotcpu notifier after initialization
Message-ID: <20130819222129.GA5262@sgi.com>
References: <1376945804-29508-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376945804-29508-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 10:56:44PM +0200, Richard Weinberger wrote:
> Currently the code initializizes mp->m_icsb_mutex and other things
> _after_ register_hotcpu_notifier().
> As the notifier takes mp->m_icsb_mutex it can happen
> that it takes the lock before it's initialization.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Looks good.  Thanks Richard.

Reviewed-by: Ben Myers <bpm@sgi.com>
