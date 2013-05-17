Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3EQSHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 14:07:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37620 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3EQSHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 14:07:37 -0400
Date: Fri, 17 May 2013 20:07:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "Wei, Gang" <gang.wei@intel.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2 2/3] driver: provide sysfs interfaces to access TXT
 config space
Message-ID: <20130517180735.GA11631@amd.pavel.ucw.cz>
References: <1368465884-14779-1-git-send-email-qiaowei.ren@intel.com>
 <1368465884-14779-3-git-send-email-qiaowei.ren@intel.com>
 <20130516160311.GA12299@amd.pavel.ucw.cz>
 <9E0BE1322F2F2246BD820DA9FC397ADE0135DF81@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE0135DF81@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2013-05-17 08:50:11, Ren, Qiaowei wrote:
> On 2013-05-17, Pavel Machek wrote:
> > On Tue 2013-05-14 01:24:43, Qiaowei Ren wrote:
> >> +What:		/sys/devices/platform/intel_txt/config/STS_raw +Date:		May 2013
> >> +KernelVersion:	3.9 +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> >> +Description:	TXT.STS is the general status register. This read-only
> >> register +		is used by AC modules and the MLE to get the status of
> >> various +		Intel TXT features.
> > 
> > This is not enough to allow people to understand what this does/should
> > do, nor does it allow (for example) ARM people to implement something compatible.
> 
> Currently TXT is only a technology for safer computing provided by Intel. I am absolutely not sure whether similar technology will be provided on ARM or other platform in future. But I guess I don't have to consider those future possible implementation on ARM or other platform. :)
> 

You still have to properly design the interface and properly document
it, so people can understand and test it, and develop compatible
implementations.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
