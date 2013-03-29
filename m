Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab3C2PSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 11:18:00 -0400
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:55703 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab3C2PR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:17:59 -0400
Date: Fri, 29 Mar 2013 19:17:54 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Sergey Yanovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, GregKH <greg@kroah.com>
Subject: Re: [PATCH] 1-wire: in-kernel notification on device events
Message-ID: <20130329151754.GA5463@ioremap.net>
References: <1363976129-21911-1-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363976129-21911-1-git-send-email-ynvich@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 10:15:29PM +0400, Sergey Yanovich (ynvich@gmail.com) wrote:
> Before this patch 1-wire subsystem didn't provide access to its
> add/remove events to other parts of the kernel. Now it is possible
> to register a standard notifier_block observer, which will be informed
> of subsequent device insertions and removals.
> 
> The framework is copied from USB subsystem.
> 
> Signed-off-by: Sergey Yanovich <ynvich@gmail.com>

Thanks Sergey, patch looks good to me
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

Greg, please pull it into your tree.
Thank you

-- 
	Evgeniy Polyakov
