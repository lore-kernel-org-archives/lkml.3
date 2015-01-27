Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbbA0Nff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:35:35 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:40411 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbbA0Nfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:35:33 -0500
Message-ID: <1422365730.1634.3.camel@gmail.com>
Subject: Re: [PATCH] samsung-laptop: enable better lid handling
From: Julijonas Kikutis <julijonas.kikutis@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: corentin.chary@gmail.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Date: Tue, 27 Jan 2015 13:35:30 +0000
In-Reply-To: <20150127025255.GA118747@vmdeb7>
References: <1418332715-10547-1-git-send-email-julijonas.kikutis@gmail.com>
	 <20150127025255.GA118747@vmdeb7>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.10 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > However, a user with another laptop in the bug report says that
"power
> > button has to be pressed twice to wake the machine" in this mode.
> 
> This is with this patch applied?

No, the commenter in bugzilla reports that it happened after manually
outputting the command to debugfs. Of course, the same command is used
by this patch only if the sysfs attribute is enabled.

> > This mode is also needed in UEFI, but there samsung-laptop is
> > unfortunately disabled.
> 
> I don't follow. What are you saying here?

samsung_init returns -ENODEV if the computer boots in UEFI. Some
functionality (e.g. the battery saving mode, SABI access for this lid
handling issue, some LED functionality for other laptops) have no
alternative ways to be accessed without this module. But this issue is
only tangentially related to my patch.

> This can be one line.

I have sent the revised patch as a reply to the first patch.

Thank you.
Julijonas

