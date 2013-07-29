Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab3G2LOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 07:14:06 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:43718 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab3G2LOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 07:14:05 -0400
Date: Mon, 29 Jul 2013 07:14:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch]workqueue: copy attr with all fields.
Message-ID: <20130729111401.GA20951@mtj.dyndns.org>
References: <20130729062412.GA6448@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729062412.GA6448@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Shaohua.

On Mon, Jul 29, 2013 at 02:24:12PM +0800, Shaohua Li wrote:
> copy_workqueue_attrs() forgets to copy no_numa field.

Explaining how that affects things and how the behavior changes
afterwards would be nice.  As it currently stands, I don't know why
you're submitting this patch.  Is this a bug fix?  Just a consistency
update?  Should it be marked with -stable?

Please put more effort into patch descriptions and also note that
->no_numa isn't a pool attribute as noted in the comment above struct
workqueue_attrs definition.

Thanks.

-- 
tejun
