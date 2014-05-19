Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaESUpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:45:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55834 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaESUpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:45:15 -0400
Date: Mon, 19 May 2014 16:34:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2014-05-15
Message-ID: <20140519203456.GK7650@tuxdriver.com>
References: <20140515135600.GB1966@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515135600.GB1966@joana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 10:56:00AM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> This pull request contains a very important fix for 3.15. Here we fix the
> permissions of a debugfs file that would otherwise allow unauthorized users
> to write content to it.
> 
> Please pull! Thanks.
> 
>         Gustavo
> 
> ---
> The following changes since commit 1fb4e09a7e780b915dbd172592ae7e2a4c071065:
> 
>   Bluetooth: Add support for Lite-on [04ca:3007] (2014-04-25 09:47:16 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git master
> 
> for you to fetch changes up to 40b9397a1a61a37917b93e7d57e6f2faf3a086b4:
> 
>   Bluetooth: Fix L2CAP LE debugfs entries permissions (2014-05-14 09:07:07 -0700)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
