Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab3BRJOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 04:14:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44911 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab3BRJOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 04:14:03 -0500
Date: Mon, 18 Feb 2013 10:13:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] hid driver transport cleanup
In-Reply-To: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1302181012320.17024@pobox.suse.cz>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013, Benjamin Tissoires wrote:

> Hi guys,
> 
> so, here is the hid drivers cleanup. The aim is to remove as much as possible
> direct calls to usbhid for hid drivers. Thus, other transport layers can use
> the existing hid drivers (like I2C or uhid).
> 
> Henrik, patches 1 to 5 are yours. I just rebased and double-checked them. Please
> add you Signed-off-by if you are happy with the rebase.

Henrik,

I can see your signoff in my inbox only for patches 1 and 2. Are you still 
reviewing patches 3-5?

Also, I'd like to make sure that we don't mess up the authorship, so 
patches 1-5 should be applied with Henrik's authorship, right? (I can do 
it after I receive signoffs from Henrik for those).

Thanks a lot for this work.

-- 
Jiri Kosina
SUSE Labs
