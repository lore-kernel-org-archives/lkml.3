Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab3BDVpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:45:31 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54932 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3BDVp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:45:29 -0500
Date: Mon, 4 Feb 2013 16:41:12 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-02-01
Message-ID: <20130204214112.GD2123@tuxdriver.com>
References: <20130201173302.GC4733@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201173302.GC4733@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 03:33:02PM -0200, Gustavo Padovan wrote:
> Hi John,
> 
> Two simple fixes for 3.8. One of the patches fixes a situation where the
> connection wasn't terminated if a timeout ocurrs for LE an SCO connections.
> The other fixes prevent NULL dereference in the SMP code, it is a security fix
> as well.
> 
> Please pull, or let me know of any problems!
> 
>         Gustavo
> 
> ---
> The following changes since commit b7e98b5100aad9290d7f06fcb9d1e80f7f62f05f:
> 
>   Bluetooth: Check if the hci connection exists in SCO shutdown (2013-01-10 03:53:32 -0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth for-upstream
> 
> for you to fetch changes up to 4c02e2d444595200d0b18b889994aac3611cd288:
> 
>   Bluetooth: Fix hci_conn timeout routine (2013-01-31 15:38:02 -0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
