Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbaIZRpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:45:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40147 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbaIZRpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:45:11 -0400
Date: Fri, 26 Sep 2014 13:39:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-09-25
Message-ID: <20140926173928.GH22967@tuxdriver.com>
References: <20140925113553.GA9506@t440s.kiipula.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925113553.GA9506@t440s.kiipula.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 02:35:53PM +0300, Johan Hedberg wrote:
> Hi John,
> 
> This 3.18 pull request replaces the one I did on Monday ("bluetooth-next
> 2014-09-22", which hasn't been pulled yet). The additions since the last
> request are:
> 
>  - SCO connection fix for devices not supporting eSCO
>  - Cleanups regarding the SCO establishment logic
>  - Remove unnecessary return value from logging functions
>  - Header compression fix for 6lowpan
>  - Cleanups to the ieee802154/mrf24j40 driver
> 
> Here's a copy from previous request that this one replaces:
> 
> "
> Here are some more patches for 3.18. They include various fixes to the
> btusb HCI driver, a fix for LE SMP, as well as adding Jukka to the
> MAINTAINERS file for generic 6LoWPAN (as requested by Alexander Aring).
> 
> I've held on to this pull request a bit since we were waiting for a SCO
> related fix to get sorted out first. However, since the merge window is
> getting closer I decided not to wait for it. If we do get the fix sorted
> out there'll probably be a second small pull request later this week.
> "
> 
> Please let me know if there are any issues pulling. Thanks.
> 
> Johan
> 
> ---
> The following changes since commit 9a783a139c32a905825ee0aa9597f485ea461f76:
> 
>   Bluetooth: Fix re-setting RPA as expired when deferring update (2014-09-12 18:34:25 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to 565766b087a6d6ff257f5b79c8ceda0188c9169f:
> 
>   Bluetooth: Rename sco_param_wideband table to esco_param_msbc (2014-09-25 10:35:08 +0200)

Pulling now, but I don't plan to push it back out until Dave pulls my earlier batch...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
