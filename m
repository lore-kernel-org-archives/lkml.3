Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbaGILpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:45:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49924 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbaGILpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:45:04 -0400
Date: Wed, 9 Jul 2014 13:45:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Anil Belur <askb23@gmail.com>
Cc: m.chehab@samsung.com, dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: media: bcm2048: radio-bcm2048.c - removed
 IRQF_DISABLED macro
Message-ID: <20140709114501.GA22777@amd.pavel.ucw.cz>
References: <1404885998-10981-1-git-send-email-askb23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404885998-10981-1-git-send-email-askb23@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-07-09 11:36:37, Anil Belur wrote:
> From: Anil Belur <askb23@gmail.com>
> 
> - this patch removes IRQF_DISABLED macro, as this is
>   deprecated/noop.
> 
> Signed-off-by: Anil Belur <askb23@gmail.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
