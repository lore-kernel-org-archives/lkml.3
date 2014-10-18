Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaJRWMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 18:12:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33678 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaJRWMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 18:12:07 -0400
Date: Sun, 19 Oct 2014 00:12:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / Runtime: Rework RPM get callback routines
Message-ID: <20141018221204.GA10843@amd>
References: <1413543482-12748-1-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413543482-12748-1-git-send-email-a.hajda@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-10-17 12:58:02, Andrzej Hajda wrote:
> PM uses three separate functions to fetch RPM callbacks.
> These functions uses quite complicated macro in their body.
> The patch replaces these routines with one small macro and
> one helper function.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>

Looks good to me.

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
