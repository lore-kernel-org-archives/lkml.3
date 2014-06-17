Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbaFQSPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 14:15:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52433 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762AbaFQSPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 14:15:12 -0400
Date: Tue, 17 Jun 2014 14:09:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2014-06-13
Message-ID: <20140617180915.GC22579@tuxdriver.com>
References: <20140613222020.GD1944@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613222020.GD1944@joana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 07:20:20PM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> This is our first batch of fixes for 3.16. Be aware that two patches here
> are not exactly bugfixes:
> 
> * 71f28af57066 Bluetooth: Add clarifying comment for conn->auth_type
> This commit just add some important security comments to the code, we found
> it important enough to include it here for 3.16 since it is security related.
> 
> * 9f7ec8871132 Bluetooth: Refactor discovery stopping into its own function
> This commit is just a refactor in a preparation for a fix in the next
> commit (f8680f128b).
> 
> All the other patches are fixes for deadlocks and for the Bluetooth protocols,
> most of them related to authentication and encryption
> 
> This is rebased on net.git of yesterday, so we need you to pull it first and then
> pull from us. This rebase was necessary for us.
> 
> Please pull or let me know of any concerns you may have. Thanks!
> 
> 	Gustavo
> 
> ---
> The following changes since commit f9da455b93f6ba076935b4ef4589f61e529ae046:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2014-06-12 14:27:40 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for-upstream
> 
> for you to fetch changes up to 92d1372e1a9fec00e146b74e8b9ad7a385b9b37f:
> 
>   Bluetooth: Allow change security level on ATT_CID in slave role (2014-06-13 14:36:39 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
