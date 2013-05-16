Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab3EPQDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:03:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54540 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3EPQDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:03:14 -0400
Date: Thu, 16 May 2013 18:03:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2 2/3] driver: provide sysfs interfaces to access TXT
 config space
Message-ID: <20130516160311.GA12299@amd.pavel.ucw.cz>
References: <1368465884-14779-1-git-send-email-qiaowei.ren@intel.com>
 <1368465884-14779-3-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368465884-14779-3-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2013-05-14 01:24:43, Qiaowei Ren wrote:
> These interfaces are located in /sys/devices/platform/intel_txt/config,
> and including totally 37 files, providing access to Intel TXT
> configuration registers.

This looks like very wrong interface... equivalent of /dev/mem.

> +What:		/sys/devices/platform/intel_txt/config/STS_raw
> +Date:		May 2013
> +KernelVersion:	3.9
> +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> +Description:	TXT.STS is the general status register. This read-only register
> +		is used by AC modules and the MLE to get the status of various
> +		Intel TXT features.

This is not enough to allow people to understand what this does/should
do, nor does it allow (for example) ARM people to implement something
compatible.

Is there specific reason why "better" interface is impossible?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
