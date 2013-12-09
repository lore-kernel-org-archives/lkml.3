Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133Ab3LIOkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:40:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36847 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3LIOkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:40:04 -0500
Date: Mon, 9 Dec 2013 15:40:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo DImitrov <ivo.g.dimitrov.75@gmail.com>
Cc: gregkh@linuxfoundation.org, joe@perches.com, omar.ramirez@copitl.com,
        pali.rohar@gmail.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2] Staging: TIDSPBRIDGE: Remove UUID helper
Message-ID: <20131209144002.GA23017@amd.pavel.ucw.cz>
References: <20131208071857.GA12104@kroah.com>
 <1386583996-5648-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386583996-5648-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-12-09 12:13:16, Ivaylo DImitrov wrote:
> From: Ivaylo Dimitrov <freemangordon@abv.bg>
> 
> Custom uuid helper function is needed only in rmgr/dbdcd.c and doesn't
> need to be exported. It can also be made way simpler by using sscanf.
> 
> Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
