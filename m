Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaBKTpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:45:25 -0500
Received: from mail.wdtv.com ([66.118.69.84]:34645 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbaBKTpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:45:21 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: make oldfonfig broken.
Date: Tue, 11 Feb 2014 14:45:19 -0500
Cc: linux-kernel@vger.kernel.org
References: <1391971686-9517-1-git-send-email-richard@nod.at> <201402101913.04969.gheskett@wdtv.com> <52FA6A62.5010000@infradead.org>
In-Reply-To: <52FA6A62.5010000@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402111445.19169.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 February 2014, Randy Dunlap wrote:
>
>You have ext[234] filesystems builtin. I suppose the rootfs is one of
>those?

Yes, its all ext2-3-4 here (except swap of course)

>Your .config file also has the ATA drivers as =m (loadable modules), but
>I guess that you also tested with those drivers =y (builtin).

Yes, both ways.
>
>I don't see what the problem is.
>You may need to try taking a photo of the failed boot and sending it to
>the mailing list (and me) again, even though that has not worked for you
>some time in the past.

I'll try it with the ext2-3-4 as modules.  But the last error was 2 lines 
farther, stalling till the BusyBox timeout after echoing the change to TSC 
clock to the low res screen.  Whatever that is.

We'll keep plodding along.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

