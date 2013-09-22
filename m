Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3IVNfx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 09:35:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55532 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab3IVNfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 09:35:52 -0400
Date: Sun, 22 Sep 2013 15:35:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: gregkh@linuxfoundation.org, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 17/19] staging: Change variable type to bool
Message-ID: <20130922133550.GA8643@amd.pavel.ucw.cz>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
 <1379802471-30252-17-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379802471-30252-17-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2013-09-22 00:27:49, Peter Senna Tschudin wrote:
> The variable Trigger is only assigned the values true and false.
> Change its type to bool.
> 
> The simplified semantic patch that find this problem is as
> follows (http://coccinelle.lip6.fr/):
> 
> @exists@
> type T;
> identifier b;
> @@
> - T
> + bool
>   b = ...;
>   ... when any
>   b = \(true\|false\)
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
