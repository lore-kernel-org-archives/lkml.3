Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3ISKLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:11:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38561 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3ISKLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:11:01 -0400
Date: Thu, 19 Sep 2013 12:11:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v3 RFT 2/2] PM / Hibernate: use name_to_dev_t to parse
 resume
Message-ID: <20130919101100.GE19346@amd.pavel.ucw.cz>
References: <1379546942-22344-1-git-send-email-sebastian.capella@linaro.org>
 <1379546942-22344-3-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379546942-22344-3-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-09-18 16:29:02, Sebastian Capella wrote:
> Use the name_to_dev_t call to parse the device name echo'd to
> to /sys/power/resume.  This imitates the method used in hibernate.c
> in software_resume, and allows the resume partition to be specified
> using other equivalent device formats as well.  By allowing
> /sys/debug/resume to accept the same syntax as the resume=device
> parameter, we can parse the resume=device in the init script and
> use the resume device directly from the kernel command line.
> 
> Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
> Cc: Len Brown <len.brown@intel.com>

Acked-by: Pavel Machek <pavel@ucw.cz>
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
