Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3B0VMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 16:12:54 -0500
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:8348 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3B0VMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 16:12:53 -0500
X-Greylist: delayed 645 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2013 16:12:52 EST
Date: Wed, 27 Feb 2013 20:58:20 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
X-X-Sender: tg@herc.mirbsd.org
To: Sedat Dilek <sedat.dilek@gmail.com>
cc: Michal Marek <mmarek@suse.cz>, Sedat Dilek <sedat.dilek@googlemail.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        maximilian attems <max@stro.at>, Alexander Wirt <formorer@debian.org>
Subject: Re: [PATCH 1/3] kbuild, deb-pkg: Try to determine distribution
In-Reply-To: <CA+icZUV993buV4VYONW2xe=rkFYdnGUAKzOi9ftQfUHK4sFRjg@mail.gmail.com>
Message-ID: <Pine.BSM.4.64L.1302272057230.19819@herc.mirbsd.org>
References: <1335219389-10887-1-git-send-email-sedat.dilek@gmail.com>
 <512E1061.3030007@suse.cz> <CA+icZUV993buV4VYONW2xe=rkFYdnGUAKzOi9ftQfUHK4sFRjg@mail.gmail.com>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I’d personally use -cs because I detest --gnu-long-options, but LGTM.

Signed-off-by: Thorsten Glaser <tg@debian.org>
