Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab3GKF5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 01:57:14 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:39128 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3GKF5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 01:57:13 -0400
Date: Thu, 11 Jul 2013 07:57:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: rebase of the jdelvare-hwmon quilt series
Message-ID: <20130711075700.21d8482c@endymion.delvare>
In-Reply-To: <20130711102724.51608a4ace419b6d42591257@canb.auug.org.au>
References: <20130711102724.51608a4ace419b6d42591257@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, 11 Jul 2013 10:27:24 +1000, Stephen Rothwell wrote:
> Why have you just rebased the jdelvare-hwmon series
> (http://khali.linux-fr.org/devel/linux-3/jdelvare-hwmon/)?  You have
> just invalidated your testing and made it likely that Linus will blast
> you if you ask him to pull your patches.  Your whole series was already
> based after v3.10 (i.e. released or rebased after the merge window
> opened), so why move it again?

I'm quite confused by this complaint of yours. I do not have the
feeling that I rebased anything or invalidated any testing. And I don't
think I did anything different this time from the way I have been
proceeding for years.

I had only 2 hwmon patches for Linus for this merge window:
  hwmon-lm63-drop-redundant-safety.patch
  hwmon-lm90-drop-redundant-safety.patch

They have been in
http://khali.linux-fr.org/devel/linux-3/jdelvare-hwmon/ (and thus in
linux-next) continuously since May 19th so I'd say they received pretty
good testing. I did not touch them, I did not even have to refresh them.

3 days ago I added these 2 patches to the hwmon-for-linus branch of my
staging tree:
http://git.kernel.org/cgit/linux/kernel/git/jdelvare/staging.git/log/?h=hwmon-for-linus
and asked Linux to pull from it.

Yesterday I reviewed a new (trivial) hwmon patch, and I accepted it, so
it was added to http://khali.linux-fr.org/devel/linux-3/jdelvare-hwmon/ as 
hwmon-w83792d-update-module-author.patch (and thus went to linux-next.)

Last night Linus pulled from
http://git.kernel.org/cgit/linux/kernel/git/jdelvare/staging.git/log/?h=hwmon-for-linus
so the 2 "old" patches are now merged upstream. The one "new" patch
is not, it will get upstream next time I ask Linus to pull from my
staging tree.

This is how things have happened, and I just can't see anything wrong.
If you do, please explain what you thing shouldn't have happened, and
let me know what I should have done instead.

Thanks,
-- 
Jean Delvare
