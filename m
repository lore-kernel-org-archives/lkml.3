Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936358AbaH1INQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:13:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934347AbaH1INM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:13:12 -0400
Date: Thu, 28 Aug 2014 01:13:06 -0700
From: Darren Hart <dvhart@infradead.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        GOESSEL Guillaume <g_goessel@outlook.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [3.17 REGRESSION FIX] Revert "ideapad-laptop: Disable touchpad
 interface on Yoga models"
Message-ID: <20140828081306.GA59286@vmdeb7>
References: <1408960813-12237-1-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408960813-12237-1-git-send-email-hdegoede@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 12:00:13PM +0200, Hans de Goede wrote:
> I've received a bug report from a user that the touchpad control part
> of the ideapad-laptop ACPI interface does work for him on his
> "Lenovo Yoga 2 13", and that this patch causes a regression for him.
> 
> Since it did not work for me when I had a "Lenovo Yoga 2 11" in my own
> hands (loaned from a friend). It seems that this is a bit of hit and miss.
> 
> Since the result of having a false positive here is worse, then the minor
> annoyance of a false touchpad disabled messages being shown after suspend /
> resume on models (or is it firmware versions?) where the interface does not
> work, simply revert the patch.
> 
> This reverts commit f79a901331a823ae370584b15cd39dd110b95a0a.
> 
> Reported-by: GOESSEL Guillaume <g_goessel@outlook.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Queued:
git://git.infradead.org/users/dvhart/linux-platform-drivers-x86.git for-linus

I'll send the pull request next week after some weekend travel.

Thanks,

--
Darren Hart
Intel Open Source Technology Center
