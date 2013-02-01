Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab3BATa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 14:30:29 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50973 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab3BATaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 14:30:25 -0500
Date: Fri, 1 Feb 2013 14:22:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2013-02-01
Message-ID: <20130201192225.GC29418@tuxdriver.com>
References: <20130201174019.GD4733@joana>
 <20130201175445.GE4733@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201175445.GE4733@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 03:54:45PM -0200, Gustavo Padovan wrote:
> Hi John,
> 
> * Gustavo Padovan <gustavo@padovan.org> [2013-02-01 15:40:19 -0200]:
> 
> > Hi John,
> > 
> > Here goes another batch intended for 3.9, the majority of the patch here are
> > from Johan who is fixing many issues in the management interface that have
> > appeared lately. The rest of the patches are just small improvements, fixes
> > and clean ups.
> 
> I had a brain shutdown moment and forgot to rebase against wireless-next.
> SO the pull request is actually much smaller.
> 
> Please pull!
> 
> 	Gustavo
> 
> ---
> The following changes since commit c331997b6c9ad7f4b8075e6e60d3caa6e36f5938:
> 
>   wil6210: fix wil_vring_init_tx status (2013-01-30 15:07:19 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream
> 
> for you to fetch changes up to a3d09356491d637548dbe815ddb966f52ec9e53a:
> 
>   Bluetooth: Refactor mgmt_pending_foreach (2013-02-01 15:50:18 -0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
