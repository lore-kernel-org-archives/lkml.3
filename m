Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbaGUVZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:25:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52231 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbaGUVZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:25:29 -0400
Date: Mon, 21 Jul 2014 23:25:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Wang YanQing <udknight@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, Joe Perches <joe@perches.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, David Fries <David@Fries.net>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: fbdev: uvesafb.c:  Cleaning up variable that is
 never used
Message-ID: <20140721212527.GC3824@amd.pavel.ucw.cz>
References: <1404564682-21983-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404564682-21983-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-07-05 14:51:22, Rickard Strandqvist wrote:
> From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>
> 
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
> 
> This was found using a static code analysis program called cppcheck

Are you sure this is right fix?

Should we be returning the error when there's error?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
