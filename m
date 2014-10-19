Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaJSKHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 06:07:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53674 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaJSKHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 06:07:42 -0400
Date: Sun, 19 Oct 2014 12:07:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org
Cc: linux-omap@vger.kernel.org
Subject: Re: USB Ethernet gadget on Nokia n900
Message-ID: <20141019100739.GA2547@amd>
References: <20141019090107.GA19132@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141019090107.GA19132@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-10-19 11:01:07, Pavel Machek wrote:
> Hi!
> 
> From 3.6 to 3.10, USB networking works on Nokia N900. With 3.11, it
> fails with messages on the host. I also tried to get it to work on
> 3.14 and 3.17, with no luck.
> 
> Any ideas? Does it work for you? Any config options to watch for?

With 3.17, I get

omap_musb_mailbox: musb core is not yet ready

message. It looks related...?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
