Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3GDQKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 12:10:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48840 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756525Ab3GDQKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:10:40 -0400
Message-ID: <1372954239.1886.40.camel@joe-AO722>
Subject: Re: [RFC] mm: Honor min_free_kbytes set by user
From: Joe Perches <joe@perches.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Thu, 04 Jul 2013 09:10:39 -0700
In-Reply-To: <1372954036-16988-1-git-send-email-mhocko@suse.cz>
References: <1372954036-16988-1-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-04 at 18:07 +0200, Michal Hocko wrote:
> A warning is printed when the new value is ignored.

[]

> +		printk(KERN_WARNING "min_free_kbytes is not updated to %d"
> +				"because user defined value %d is preferred\n",
> +				new_min_free_kbytes, user_min_free_kbytes);

Please use pr_warn and coalesce the format.
You'd've noticed a missing space between %d and because.


