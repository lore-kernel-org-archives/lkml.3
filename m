Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945922AbaDQNQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:16:20 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55442 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbaDQNQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:16:19 -0400
Date: Thu, 17 Apr 2014 09:16:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Glyn Normington <gnormington@gopivotal.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] control groups: documentation improvements
Message-ID: <20140417131615.GH26632@htj.dyndns.org>
References: <20140310142014.GC25290@htj.dyndns.org>
 <5321D6FA.4040500@gopivotal.com>
 <53225C69.3010202@huawei.com>
 <53230475.5050805@gopivotal.com>
 <20140314140136.GF12613@htj.dyndns.org>
 <53230C7E.7060607@gopivotal.com>
 <533C05D8.8020600@gopivotal.com>
 <533C0DD9.1050809@gopivotal.com>
 <20140416210025.GE26632@htj.dyndns.org>
 <534FB0F5.3010904@gopivotal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534FB0F5.3010904@gopivotal.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glyn.

On Thu, Apr 17, 2014 at 11:46:13AM +0100, Glyn Normington wrote:
> +There may be zero or more active hierarchies. Each hierarchy has an
> +instance of the cgroup virtual filesystem associated with it. The tree
> +of cgroups is represented by the directory tree in the cgroup virtual
> +filesystem.
> +
> +The sets of subsystems participating in distinct hierarchies are either
> +identical or disjoint. If the sets are identical, the virtual filesystems
> +associated with the hierarchies have identical content and a change in
> +one is automatically reflected in all the others.

I can't say I'm a big fan of these definitions in mathematical terms.
They're so precise and useless at the same time.  That said, I don't
really understand the last paragraph.  Is it trying to talk about
multiple mounts of a single hierarchy?

Thanks.

-- 
tejun
