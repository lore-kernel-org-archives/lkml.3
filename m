Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaBXA3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 19:29:18 -0500
Received: from p3plsmtpa07-08.prod.phx3.secureserver.net ([173.201.192.237]:57221
	"EHLO p3plsmtpa07-08.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbaBXA3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 19:29:15 -0500
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Feb 2014 19:29:15 EST
From: Andy Johnson <andy@asjohnson.com>
To: linux-kernel@vger.kernel.org
Reply-To: andy@asjohnson.com
Subject: IO_PAGE_FAULT in 3.13.5
Date: Sun, 23 Feb 2014 18:21:23 -0600
Message-ID: <11058770.VGBV2VhNFW@dads>
User-Agent: KMail/4.10.5 (Linux/3.13.5-asj; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting a combination of the following two messages about 500 times in dmesg in 3.13.5:

[    0.358123] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:13.0 domain=0x000f address=0x00000000ffffffc0 flags=0x0010]
[    0.358124] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x000d address=0x00000000ffffffc0 flags=0x0010]

This didn't happen in 3.13.2. The two devices correspond to the OHCI controllers.
I compiled this myself from source from kernel.org, on Slackware 14.1. Let me know
what other information is needed about my system. I didn't want to post a ton of
stuff that might not be relevant. This also happened with a b43 supported wireless
card I had, but I swapped it out with an Atheros based card and the problem went away.

Please CC me,

Andy Johnson

