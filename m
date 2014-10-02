Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaJBSAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:00:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40549 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaJBSAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:00:11 -0400
Date: Thu, 2 Oct 2014 13:57:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-10-02
Message-ID: <20141002175717.GC12208@tuxdriver.com>
References: <20141002151457.GA3129@t440s.P-661HNU-F1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002151457.GA3129@t440s.P-661HNU-F1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 06:14:57PM +0300, Johan Hedberg wrote:
> Hi John,
> 
> Unless 3.17 gets delayed this will probably be our last -next pull request for
> 3.18. We've got:
> 
>   - New Marvell hardware supportr
>   - Multicast support for 6lowpan
>   - Several of 6lowpan fixes & cleanups
>   - Fix for a (false-positive) lockdep warning in L2CAP
>   - Minor btusb cleanup
> 
> Please let me know if there are any issues pulling. Thanks.
> 
> Johan
> 
> ---
> The following changes since commit 565766b087a6d6ff257f5b79c8ceda0188c9169f:
> 
>   Bluetooth: Rename sco_param_wideband table to esco_param_msbc (2014-09-25 10:35:08 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to 9c238ca8ec79c38ab22762b44aeaf7a42fc97b18:
> 
>   Bluetooth: 6lowpan: Check transmit errors for multicast packets (2014-10-02 13:41:57 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
