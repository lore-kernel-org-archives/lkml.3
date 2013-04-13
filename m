Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3DMVCu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 17:02:50 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:43802 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3DMVCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 17:02:49 -0400
Message-ID: <1365886961.1089.6.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 6/7] backports: add media subsystem drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: backports@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Sat, 13 Apr 2013 23:02:41 +0200
In-Reply-To: <1365862424-6530-7-git-send-email-mcgrof@do-not-panic.com> (sfid-20130413_161421_323308_27727044)
References: <1365862424-6530-1-git-send-email-mcgrof@do-not-panic.com>
	 <1365862424-6530-7-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20130413_161421_323308_27727044)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-04-13 at 07:13 -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> This adds backport support for all media subsystem
> drivers. This is enabled only for >= 3.2. Some media
> drivers rely on the new probe deferrral mechanism
> (-EPROBE_DEFER see commit d1c3414c), those are only
> enabled for kernels >= 3.4. Some media drivers only
> depend on the regulatory but since we only support
> backporting the regulatory on kernels >= 3.4 we only
> enable those media drivers for >= 3.4.
> 
> This backports 433 media drivers.

Heh. Applied. Good thing I can kill the pr_fmt patches again soon.

johannes

