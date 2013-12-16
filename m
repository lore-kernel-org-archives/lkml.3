Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3LPIqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 03:46:13 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:31156 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3LPIqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 03:46:11 -0500
Date: Mon, 16 Dec 2013 09:45:57 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the jdelvare-hwmon tree with Linus'
  tree
Message-ID: <20131216094557.3391bb6a@endymion.delvare>
In-Reply-To: <20131216115733.16a652c0e350453d94c8551a@canb.auug.org.au>
References: <20131216115733.16a652c0e350453d94c8551a@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, 16 Dec 2013 11:57:33 +1100, Stephen Rothwell wrote:
> Today's linux-next merge of the jdelvare-hwmon tree got a conflict in
> drivers/hwmon/lm90.c between commits from Linus' tree and commits from
> the jdelvare-hwmon tree.
> 
> It looks like the jdelvare-hwmon patch series has been reset back
> (unintentionally?) to stuff that has already been merged into Linus'
> tree ... so I just used the version from Linus' tree.

Oops. Yes, that was totally unintentional.

I had my ISP change some settings for my web hosting, and all my data
was deleted in the process. I kind of expected that, so I made a
complete backup before asking for the change. Unfortunately I did not
expect them to take so long to acknowledge my request and act upon it,
so when I restored my backup, my web space indeed went back in time by
several weeks.

I manually updated everything I remembered having touched during that
time frame, but as you spotted rightly, I forgot my kernel patch series.

This is all fixed now, sorry for the noise and thanks for letting me
know.

-- 
Jean Delvare
