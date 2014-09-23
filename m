Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbaIWPAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:00:22 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39766 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbaIWPAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:00:15 -0400
Date: Tue, 23 Sep 2014 10:46:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Joe Perches <joe@perches.com>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wil6210 <wil6210@qca.qualcomm.com>, ath6kl@lists.infradead.org
Subject: Re: [PATCH] ath: change logging functions to return void
Message-ID: <20140923144627.GG23806@tuxdriver.com>
References: <1411407334.2952.46.camel@joe-AO725>
 <874mvzj7bu.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874mvzj7bu.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:20:53AM +0300, Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
> 
> > The return values are not used by callers of these functions
> > so change the functions to return void.
> >
> > Other miscellanea:
> >
> > o add __printf verification to wil6210 logging functions
> >   No format/argument mismatches found
> >
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> > This change is associated to a desire to eventually
> > change printk to return void.
> >
> >  drivers/net/wireless/ath/ath10k/debug.c    | 18 +++++-------------
> >  drivers/net/wireless/ath/ath10k/debug.h    |  6 +++---
> >  drivers/net/wireless/ath/ath6kl/common.h   |  2 +-
> >  drivers/net/wireless/ath/ath6kl/debug.c    | 28 ++++++++--------------------
> >  drivers/net/wireless/ath/ath6kl/debug.h    | 13 ++++++-------
> 
> For ath6kl and ath10k:
> 
> Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> >  drivers/net/wireless/ath/wil6210/debug.c   | 14 ++++----------
> >  drivers/net/wireless/ath/wil6210/wil6210.h |  7 +++++--
> >  7 files changed, 32 insertions(+), 56 deletions(-)
> 
> John, as this patch also contains a wil6210 change how do you want to
> handle this?

I had presumed that you would merge it through the ath tree, so I
deleted it...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
