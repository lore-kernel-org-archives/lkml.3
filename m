Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbaC0SaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 14:30:17 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56479 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681AbaC0SaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 14:30:14 -0400
Date: Thu, 27 Mar 2014 14:18:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-03-24
Message-ID: <20140327181849.GG31168@tuxdriver.com>
References: <20140324173332.GA2214@joana>
 <20140326183411.GB1741@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140326183411.GB1741@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 03:34:11PM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> 2014-03-24 Gustavo Padovan <gustavo@padovan.org>:
> 
> > Hi John,
> > 
> > Here follow another set of patches to 3.15. This is mostly a bug fix pull
> > request with the exception of one commit from Marcel which adds tracking to
> > the current configured LE scan type parameter.
> 
> There is one more fix that we want to include in this pull request. Here
> follows a new pull request, please pull, Thanks. 
> 
> 	Gustavo
> 
> --
> The following changes since commit 40b552aa5a0bfa785bc7ddb5c2d7965b1e0bb08d:
> 
>   Bluetooth: Enforce strict Secure Connections Only mode security (2014-03-19 23:30:32 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to e8b1ab9e6d30394e0df3e4f60bf56c4dc9bf0863:
> 
>   Bluetooth: Fix returning peer address in pending connect state (2014-03-26 09:31:33 -0700)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
