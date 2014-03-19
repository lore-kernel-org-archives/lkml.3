Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaCSTP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:15:26 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47464 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbaCSTPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:15:17 -0400
Date: Wed, 19 Mar 2014 15:15:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: pull request: iwlwifi 2014-03-19
Message-ID: <20140319191504.GB3355@tuxdriver.com>
References: <532939A0.9000901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532939A0.9000901@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 08:30:56AM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> This fixes the build failure faced by Stephen:
> 
> drivers/net/wireless/iwlwifi/mvm/debugfs.c: In function 'iwl_dbgfs_fw_error_dump_release':
> drivers/net/wireless/iwlwifi/mvm/debugfs.c:161:2: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
>   vfree(file->private_data);
>   ^
> 
> Please pull.
> 
> 
> The following changes since commit a82dda6cd492b8c88952be6f6527f3656f7ac585:
> 
>   iwlwifi: mvm: disable uAPSD due to bugs in the firmware (2014-03-18 21:15:42 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to 192c80a2499cf2571924081c646262036d841484:
> 
>   iwlwifi: mvm: add missing include (2014-03-19 08:25:05 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
