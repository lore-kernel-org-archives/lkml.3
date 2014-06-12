Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaFLAnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:43:01 -0400
Received: from ns.horizon.com ([71.41.210.147]:32361 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752875AbaFLAnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:43:00 -0400
Date: 11 Jun 2014 20:42:59 -0400
Message-ID: <20140612004259.14821.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: drivers/char/random.c: more ruminations
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140611131140.GD23110@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's not something where if the changes required massive changes, that
> I'd necessarily feel the need to backport them to stable.  It's a
> certificational weakness, but it's a not disaster.

Agreed!  It's been there for years, and I'm not too worried.  It takes
a pretty tight race to cause the problem in the first place.

As you note, it only happens with a full pool (already a very secure
situation), and the magnitude is limited by the size of entropy additions,
which are normally small.

I'm just never happy with bugs in security-critical code.  "I don't
think that bug is exploitable" is almost as ominous a phrase as "Y'all
watch this!"
