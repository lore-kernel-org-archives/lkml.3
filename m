Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbaE3LeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:34:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57061 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbaE3LeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:34:20 -0400
Date: Fri, 30 May 2014 13:34:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miguel Oliveira <cmroliv@gmail.com>
Cc: gregkh@linuxfoundation.org, gulsah.1004@gmail.com, pali.rohar@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range()
 instead of msleep()
Message-ID: <20140530113418.GA9670@amd.pavel.ucw.cz>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-05-30 11:27:13, Miguel Oliveira wrote:
> Creating this patch for the Eudyptula Challenge.
> Replaced msleep() for a delay < 20ms with a usleep_range() between 10000us and 15000us.
> Also inserted a blank line after adeclaration.

So you are changing timings without testing. Plus, burning CPU power
instead of sleeping.

Seems you'll need another patch for the challenge :-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
