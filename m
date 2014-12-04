Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaLDBj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:39:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaLDBj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:39:26 -0500
Date: Wed, 3 Dec 2014 17:39:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: arun vijayshankar <arun267@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] Staging: bcm: Fix lines exceeding 80 character limit in
 CmHost.h This is a patch to CmHost.h that fixes Exceeds 80 Character limits
 warning found by checkpatch.pl Signed-off-by: Arun Ayyer <arun267@gmail.com>
Message-ID: <20141204013925.GA32401@kroah.com>
References: <1417655529-8640-1-git-send-email-arun267@gmail.com>
 <20141204012517.GA31563@kroah.com>
 <CAJ8d=beEFz-wKaN4bodZFN9BCrUsZKy=F0e-R7fUVXsf+04g4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8d=beEFz-wKaN4bodZFN9BCrUsZKy=F0e-R7fUVXsf+04g4A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 05:31:59PM -0800, arun vijayshankar wrote:
> Hi Greg,

If you turn off HTML email, your message will not get rejected by the
mailing lists :)

> I completely agree! I thought of keeping the patch summary as the subject, but
> I wasn't sure and ending up entering nothing. Git then used this by default.

You forgot a blank line after your first line in the git commit message,
which caused it to get all merged together.

Try fixing that up and resending please.

thanks,

greg k-h
