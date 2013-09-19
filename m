Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3ISKKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:10:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38543 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3ISKKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:10:36 -0400
Date: Thu, 19 Sep 2013 12:10:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Warren <swarren@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 RFT 1/2] init/do_mounts.c: ignore final \n in
 name_to_dev_t
Message-ID: <20130919101034.GD19346@amd.pavel.ucw.cz>
References: <1379546942-22344-1-git-send-email-sebastian.capella@linaro.org>
 <1379546942-22344-2-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379546942-22344-2-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-09-18 16:29:01, Sebastian Capella wrote:
> Enhance name_to_dev_t to handle trailing newline characters
> on device paths.  Some inputs to name_to_dev_t may come from
> userspace where oftentimes a '\n' is appended to the path.
> Added const to the name buffer in both the function
> declaration and the prototype to reflect input buffer
> handling.
> 
> By handling trailing newlines in name_to_dev_t, userspace
> buffers may be directly passed to name_to_dev_t without
> modification.
> 
> Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
> Cc: Pavel Machek <pavel@ucw.cz>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
