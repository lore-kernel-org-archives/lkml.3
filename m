Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaCSTPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:15:22 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47467 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaCSTPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:15:17 -0400
Date: Wed, 19 Mar 2014 15:14:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (wireless-next tree related)
Message-ID: <20140319191426.GA3355@tuxdriver.com>
References: <20140319172035.b4e7c4043b486d8eeaa0534a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319172035.b4e7c4043b486d8eeaa0534a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 05:20:35PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc allyesconfig)
> failed like this:
> 
> drivers/net/wireless/iwlwifi/mvm/debugfs.c: In function 'iwl_dbgfs_fw_error_dump_release':
> drivers/net/wireless/iwlwifi/mvm/debugfs.c:161:2: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
>   vfree(file->private_data);
>   ^
> 
> Caused by commit 1bd3cbc1a0e9 ("iwlwifi: mvm: send udev event upon
> firmware error to dump logs") from the wireless-next tree.  See Rule 1
> from Documentation/SubmitChecklist.
> 
> I have reverted that commit (and commit cdb00563fe2c ("iwlwifi: mvm: BT
> Coex - add debugfs hook to set BT Tx priority") that may depend on it)
> for today.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

Clearly I need to beg someone for a powerpc box, so that I can find
more of these build failures... :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
