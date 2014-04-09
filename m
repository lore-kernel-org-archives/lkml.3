Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaDIFXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 01:23:48 -0400
Received: from relaygw1-11.mclink.it ([213.21.178.166]:54623 "EHLO
	relaygw1-11.mclink.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaDIFXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 01:23:47 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2014 01:23:47 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiMFAIDVRFNNK3Ai/2dsb2JhbABZgwbGYhZ0giYBAQQ6LhEQAQohJQ9IiBkBynwXjwmDDoEUAQOYXAGSQYMyOw
Date: Wed, 9 Apr 2014 07:08:43 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: jet.chen@intel.com
Cc: gregkh@linuxfoundation.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [FMC] BUG: scheduling while atomic: swapper/1/0x10000002
Message-ID: <20140409050843.GA18949@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <5344BF60.5050300@intel.com>
References: <5344BF60.5050300@intel.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
Thank you for the report.

I'm at a conference and I fear I won't be able to test myself in the
next days, but I think this is already fixed (it is part of
the "misc_register" call path, so it's the same problem).

The fix is commit v3.11-rc2-11-g783c2fb

   783c2fb FMC: fix locking in sample chardev driver

This commit, however, is not part of v3.11 and I think this is why you
are finding the problem in the v3.10..v3.11 interval.

thank you again
/alessandro
