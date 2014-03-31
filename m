Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaCaOtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:49:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54373 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbaCaOtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:49:43 -0400
Date: Mon, 31 Mar 2014 16:49:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, hpa@zytor.com, linux-efi@vger.kernel.org,
        jmorris@namei.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 09/12] uswsusp: Disable when trusted_kernel is true
Message-ID: <20140331144935.GB21805@xo-6d-61-c0.localdomain>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
 <1393445473-15068-10-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393445473-15068-10-git-send-email-matthew.garrett@nebula.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-02-26 15:11:10, Matthew Garrett wrote:
> uswsusp allows a user process to dump and then restore kernel state, which
> makes it possible to modify the running kernel. Disable this if
>  trusted_kernel is true.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

It can also enter S3 etc...

And dumping the kernel state should not be a problem, right? Only restoring is....

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
