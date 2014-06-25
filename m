Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbaFYSaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:30:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54337 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbaFYSaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:30:11 -0400
Date: Wed, 25 Jun 2014 14:22:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2014-06-25
Message-ID: <20140625182256.GD3445@tuxdriver.com>
References: <20140625143006.GA18018@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625143006.GA18018@joana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:30:06AM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> A few fixes for 3.16. This pull request contains a NULL dereference fix,
> and some security/pairing fixes. Please pull. Thanks!
> 
> 	Gustavo
> 
> ---
> The following changes since commit 616a8394b5df8c88f4dd416f4527439a4e365034:
> 
>   rt2x00: fix rfkill regression on rt2500pci (2014-06-17 14:11:16 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for-upstream
> 
> for you to fetch changes up to 48439d501e3d9e8634bdc0c418e066870039599d:
> 
>   Bluetooth: Ignore H5 non-link packets in non-active state (2014-06-23 18:22:48 +0200)
> 
> ----------------------------------------------------------------
> Johan Hedberg (3):
>       Bluetooth: Fix overriding higher security level in SMP
>       Bluetooth: Refactor authentication method lookup into its own function
>       Bluetooth: Fix rejecting pairing in case of insufficient capabilities
> 
> Loic Poulain (1):
>       Bluetooth: Ignore H5 non-link packets in non-active state
> 
> Lukasz Rymanowski (1):
>       Bluetooth: Fix for ACL disconnect when pairing fails
> 
> Marcel Holtmann (1):
>       Revert "Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012."

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
