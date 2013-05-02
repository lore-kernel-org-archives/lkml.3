Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab3EBXUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 19:20:42 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:55314 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3EBXUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 19:20:40 -0400
Date: Thu, 2 May 2013 16:20:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 01/10] freezer: shorten freezer sleep time using
 exponential backoff
Message-ID: <20130502232034.GU19814@mtj.dyndns.org>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
 <1367458508-9133-2-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367458508-9133-2-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 01, 2013 at 06:34:59PM -0700, Colin Cross wrote:
> All tasks can easily be frozen in under 10 ms, switch to using
> an initial 1 ms sleep followed by exponential backoff until
> 8 ms.  Also convert the printed time to ms instead of centiseconds.

Can you please put the above as comment in the code?  Other than that,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
