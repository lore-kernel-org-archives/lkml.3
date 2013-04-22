Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab3DVS5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 14:57:18 -0400
Received: from sapphire.tuxdriver.com ([70.61.120.61]:47786 "EHLO
	linville-x1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754579Ab3DVS5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 14:57:16 -0400
Date: Mon, 22 Apr 2013 14:57:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2013-04-18
Message-ID: <20130422185713.GE2055@tuxdriver.com>
References: <20130418044836.GB29635@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418044836.GB29635@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 01:48:36AM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> A set of changes intended for 3.10. The biggest changes here are from David
> Herrmann, he rewrote most of the HIDP layer making it more reliable. Marcel
> added a driver setup stage for device that need special handling on their
> early initialization. Other than that we have the usual clean ups, bugfixes
> and small improvements.
> 
> Please pull or let me know of any problems! Thanks!
> 
> 	Gustavo
> 
> ---
> The following changes since commit 84bcc0c3c4b8ca4c0abed2d2dd63b7ce04f8be0e:
> 
>   brcmfmac: enable sk_buff queueing when credits deplete (2013-04-03 15:07:09 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream
> 
> for you to fetch changes up to 76a388beaf92cc75b829d4a0b7d69afaaeaa4b0a:
> 
>   Bluetooth: Rename LE_SCANNING_* macros (2013-04-18 01:17:27 -0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
