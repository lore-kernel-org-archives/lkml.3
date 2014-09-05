Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbaIEH7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:59:46 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:40665 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaIEH7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:59:45 -0400
Message-ID: <1409903983.9532.0.camel@linux-fkkt.site>
Subject: Re: [3.16.1 REGRESSION]: Simtec Entropy Key (cdc-acm) broken in 3.16
From: Oliver Neukum <oliver@neukum.org>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 05 Sep 2014 09:59:43 +0200
In-Reply-To: <874mwnosz1.fsf@spindle.srvr.nix>
References: <878um4tg09.fsf@spindle.srvr.nix>
	 <1409569752.24385.12.camel@linux-fkkt.site>
	 <874mwnosz1.fsf@spindle.srvr.nix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-05 at 00:40 +0100, Nix wrote:
> I'm working around this confusing morass by rebooting into each test
> kernel, unplugging and replugging the entropy key if it was fubared,
> then rebooting into the same kernel again and seeing if it was still
> fubared. But this is not terribly fast, particularly not on a headless
> compact-flash-based Geode box which doesn't even complete booting
> without the entropy source which this bug cuts off :) so it'll be
> sometime tomorrow before I can get this bisection done, I'm afraid.

Ugh. My sympathies. I cannot suggest a better method, I am afraid.

	Regards
		Oliver


