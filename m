Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab3IWKmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:42:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53065 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3IWKml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:42:41 -0400
Date: Mon, 23 Sep 2013 12:42:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: lenb@kernel.org, linux-acpi@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: Re: thinkpad x60: critical thermal shutdown does not work (and
 ethernet overheats)
Message-ID: <20130923095814.GA2052@Nokia-N900>
References: <20120515181004.GA2499@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515181004.GA2499@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I have rather old thinkpad x60 here. Long time ago, I noticed that on
> high continuous ethernet load, it shuts itself down in regular
> way. I traced it down to overheat, followed by ACPI signaling system
> to go down.

just to wrap the story up... after fixing pcie aspm problems,
ethernet apparently stopped overheating.

					pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
