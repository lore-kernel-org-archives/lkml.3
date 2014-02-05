Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbaBEVie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:38:34 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57669 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754330AbaBEVib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 16:38:31 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: gregkh@linuxfoundation.org, pavel@ucw.cz, len.brown@intel.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhuangzhi.li@intel.com
Subject: Re: [PATCH 0/5] Enabling the asynchronous threads for other phases
Date: Wed, 05 Feb 2014 22:53:01 +0100
Message-ID: <2360514.bLFmJYMItS@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
References: <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 20, 2014 04:44:34 PM Liu, Chuansheng wrote:
> Hello,
> 
> This patch series are for enabling the asynchronous threads for the phases
> resume_noirq, resume_early, suspend_noirq and suspend_late.
> 
> Just like commit 5af84b82701a and 97df8c12995, with async threads it will
> reduce the system suspending and resuming time significantly.
> 
> With these patches, in my test platform, it saved 80% time in resume_noirq
> phase.
> 
> Has done the suspend-resume stress test for a long time, please help to
> review.
> 
> Best Regards,
> 
> [PATCH 1/5] PM: Adding two flags for async suspend_noirq and
> [PATCH 2/5] PM: Enabling the asynchronous threads for resume_noirq
> [PATCH 3/5] PM: Enabling the asyncronous threads for resume_early
> [PATCH 4/5] PM: Enabling the asyncronous threads for suspend_noirq
> [PATCH 5/5] PM: Enabling the asyncronous threads for suspend_late

I've applied this to the bleeding-edge branch of the linux-pm.git tree, with
minor changes related to coding style, white space etc.

Can you please verify that the bleeding-edge branch works for you as expected?

Rafael

