Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030762AbaGRRpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:45:19 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50393 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030575AbaGRRpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:45:13 -0400
Date: Fri, 18 Jul 2014 13:42:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-07-14
Message-ID: <20140718174203.GE31114@tuxdriver.com>
References: <20140714214944.GA4374@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714214944.GA4374@joana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 06:49:44PM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> Some more patches for 3.17. The most important change here is the move of
> the 6lowpan code to net/6lowpan. It has been agreed with Davem that this
> change will go through the bluetooth tree. The rest are mostly clean up and
> fixes.
> 
> Please pull! or let me know of any issues. Thanks!
> 
> 	Gustavo
> 
> ---
> The following changes since commit 6fea7ad1d338dba592d65423427a997f1b7ff485:
> 
>   Bluetooth: Don't send ERTM configuration option when disabled (2014-07-09 13:53:36 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to 4d042654afb342386cb5c33e29843b76d598ab61:
> 
>   Bluetooth: cmtp: Remove unnecessary null test (2014-07-14 23:00:13 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
