Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab3KFWmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:42:44 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57514 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3KFWmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:42:43 -0500
Date: Wed, 6 Nov 2013 23:42:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, sre@debian.org,
        sre@ring0.de
Cc: Jenny TC <jenny.tc@intel.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: gitorious v3.12-rc1-n900 tree
Message-ID: <20131106224241.GA5837@amd.pavel.ucw.cz>
References: <201310240806.49340@pali>
 <20131026002500.GA16970@earth.universe>
 <20131105120016.GA30670@amd.pavel.ucw.cz>
 <201311051336.00159@pali>
 <20131105231241.GA5065@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105231241.GA5065@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-11-06 00:12:41, Pavel Machek wrote:
> Hi!
> 
> > > I tried pulling current linux-n900 tree from gitorious.
> > 
> > Hi, use branch v3.12-rc5-n900 (not -rc1) and consider using 
> > rx51_defconfig.
> 
> rx51_defconfig works for me, thanks.
> 
> And here are fixes for the problems I hit... please apply,
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

(the patch is still needed with v3.12-rc5-n900 branch).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
