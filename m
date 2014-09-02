Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaIBMzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:55:21 -0400
Received: from tundra.namei.org ([65.99.196.166]:34403 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbaIBMzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:55:19 -0400
Date: Tue, 2 Sep 2014 22:55:12 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
cc: james.l.morris@oracle.com, serge@hallyn.com,
        Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] security: Silence shadow warning
In-Reply-To: <1409226189-2369-1-git-send-email-jeffrey.t.kirsher@intel.com>
Message-ID: <alpine.LRH.2.11.1409022255001.7126@namei.org>
References: <1409226189-2369-1-git-send-email-jeffrey.t.kirsher@intel.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014, Jeff Kirsher wrote:

> From: Mark Rustad <mark.d.rustad@intel.com>
> 
> Renaming an unused formal parameter in the static inline function
> security_inode_init_security eliminates many W=2 warnings.
> 
> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>

