Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab3KUVSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:18:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50228 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab3KUVSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:18:30 -0500
Date: Thu, 21 Nov 2013 21:18:25 +0000
From: Mark Einon <mark.einon@gmail.com>
To: ZHAO Gang <gamerh2o@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v3 0/5] staging: et131x: patches for et131x driver
Message-ID: <20131121211822.GA10691@einon.net>
References: <cover.1384933520.git.gamerh2o@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1384933520.git.gamerh2o@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 03:53:50PM +0800, ZHAO Gang wrote:
> This patch set should apply to current staging-next tree
> 
> ZHAO Gang (5):
>   staging: et131x: clean up code
>   staging: et131x: drop packet when error occurs in et131x_tx
>   staging: et131x: stop read when hit max delay in et131x_phy_mii_read
>   staging: et131x: remove spinlock adapter->lock
>   staging: et131x: update TODO list
> 
>  drivers/staging/et131x/README   |   5 -
>  drivers/staging/et131x/et131x.c | 301 +++++++++++++++++-----------------------
>  2 files changed, 127 insertions(+), 179 deletions(-)
> 
> -- 

Hi Zhao,

Thanks for the patches. A few pointers for the future:

- Use scripts/get_maintainer.pl to discover to which mailing lists /
maintainers patches should be sent. I've cc'd devel@driverdev.osuosl.org
which was missing from your original submission.

- Please don't roll up patches you've previously sent into newer
patchsets, even if they haven't been applied by the tree maintainer
yet. This just means that the same lines of code get reviewed twice,
wasting the reviewer's time.

Cheers,

Mark
