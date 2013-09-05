Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935839Ab3IEMZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:25:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58728 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab3IEMZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:25:02 -0400
Date: Thu, 5 Sep 2013 14:25:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@lists.infradead.org, linux-pm@vger.kernel.org,
        linaro-dev@lists.linaro.org, Rob Landley <rob@landley.net>,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        trivial@kernel.org
Subject: Re: [PATCH v2 RFT 2/2] PM / Hibernate: add section for resume
 options
Message-ID: <20130905122500.GE15161@amd.pavel.ucw.cz>
References: <1377652437-2379-1-git-send-email-sebastian.capella@linaro.org>
 <1377652437-2379-3-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377652437-2379-3-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue 2013-08-27 18:13:57, Sebastian Capella wrote:
> Expand the existing documentation to explicitly list the options for
> resuming a hibernation image, including the manual resume option which
> can be used from the initrd or initramfs and the kernel init resume.

...it also fixes sysfs path in second hunk.

> Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
> Cc: Rob Landley <rob@landley.net>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>

Acked-by: Pavel Machek <pavel@ucw.cz>

(Cc-ed trivial so this does not get lost).

> @@ -326,7 +339,7 @@ Q: How can distributions ship a swsusp-supporting kernel with modular
>  disk drivers (especially SATA)?
>  
>  A: Well, it can be done, load the drivers, then do echo into
> -/sys/power/disk/resume file from initrd. Be sure not to mount
> +/sys/power/resume file from initrd. Be sure not to mount
>  anything, not even read-only mount, or you are going to lose your
>  data.
>  


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
