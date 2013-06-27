Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3F0Pox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:44:53 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35994 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3F0Pow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:44:52 -0400
Date: Fri, 28 Jun 2013 00:44:23 +0900
From: Minchan Kim <minchan@kernel.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mhocko@suse.cz,
        anton@enomsg.org, akpm@linux-foundation.org, kmpark@infradead.org,
        hyunhee.kim@samsung.com
Subject: Re: [PATCH v2] vmpressure: implement strict mode
Message-ID: <20130627154423.GB5006@gmail.com>
References: <20130626231712.4a7392a7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626231712.4a7392a7@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 11:17:12PM -0400, Luiz Capitulino wrote:
> Currently, an eventfd is notified for the level it's registered for
> _plus_ higher levels.
> 
> This is a problem if an application wants to implement different
> actions for different levels. For example, an application might want
> to release 10% of its cache on level low, 50% on medium and 100% on
> critical. To do this, an application has to register a different
> eventfd for each pressure level. However, fd low is always going to
> be notified and and all fds are going to be notified on level critical.
> 
> Strict mode solves this problem by strictly notifiying an eventfd
> for the pressure level it registered for. This new mode is optional,
> by default we still notify eventfds on higher levels too.
> 
> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>

If you will update this patch without major big change, you can keep
earlier Acked-by and Reviewe-by.

Thanks!

