Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab3HLKFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:05:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60205 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab3HLKFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:05:12 -0400
Date: Mon, 12 Aug 2013 12:05:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: gregkh@linuxfoundation.org, justinmattock@gmail.com, mujeeb.adil@gmail.com,
        harsh1kumar@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Staging: winbond: wb35reg: changed sleep function
 from msleep to usleep
Message-ID: <20130812100510.GA21492@amd.pavel.ucw.cz>
References: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
 <1375696712-5276-2-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375696712-5276-2-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-08-05 11:58:27, Iker Pedrosa wrote:
> Changed sleep function from msleep to usleep according to the documentation.
> 
> Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>

Can you explain why this is good idea?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
