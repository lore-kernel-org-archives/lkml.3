Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3IZAD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 20:03:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35351 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3IZAD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 20:03:56 -0400
Date: Thu, 26 Sep 2013 02:03:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: gregkh@linuxfoundation.org, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH v3 21/24] Staging: winbond: wb35tx: Replace printk with
 netdev
Message-ID: <20130926000354.GB25716@amd.pavel.ucw.cz>
References: <1379339024-12157-22-git-send-email-ikerpedrosam@gmail.com>
 <1380119969-21267-1-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380119969-21267-1-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-09-25 16:39:29, Iker Pedrosa wrote:
> The previously used printk lacked the warning level, now we've got a more accurate way to know the error.
> 
> Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
