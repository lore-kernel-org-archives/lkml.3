Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaGBOdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:33:07 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:44153 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaGBOdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:33:04 -0400
Date: Wed, 2 Jul 2014 10:33:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Binder Makin <merimus@google.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, dmj@google.com,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
Subject: Re: [RFC] cgroups: Resource controller for open files.
Message-ID: <20140702143300.GB23275@htj.dyndns.org>
References: <1404311407-4851-1-git-send-email-merimus@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404311407-4851-1-git-send-email-merimus@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 02, 2014 at 10:30:07AM -0400, Binder Makin wrote:
> Add a resource controller for limiting the number of open
> file handles.  This allows us to catch misbehaving processes
> and return EMFILE instead of ENOMEM for kernel memory limits.

cc'ing memcg people.  Isn't kmemcg supposed to cover this by
controlling kernel memory usage?

Thanks.

-- 
tejun
