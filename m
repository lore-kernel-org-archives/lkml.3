Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaK3WbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 17:31:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56128 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaK3WbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 17:31:05 -0500
Date: Sun, 30 Nov 2014 23:31:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Michael Shell <list1@michaelshell.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Standard VGA console with DRI/DRM under X?
Message-ID: <20141130223101.GA2322@amd>
References: <20141028023208.320b777b6ad97c7c9a815300@michaelshell.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028023208.320b777b6ad97c7c9a815300@michaelshell.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On
> One reason I do not wish to use the framebuffer console is because of the
> small font. 160 columns makes it difficult to tell which [OK] belongs with
> which service. The selection of console fonts should always include a
> set that gives us an 80 column screen and the docs should point this
>out.

Take a look at kernel config, and select a bigger font.
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
