Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab3KMXX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 18:23:58 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56126 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3KMXXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:23:51 -0500
Date: Thu, 14 Nov 2013 00:23:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
Message-ID: <20131113232349.GA13970@amd.pavel.ucw.cz>
References: <1381450698-28710-4-git-send-email-keescook@chromium.org>
 <tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org>
 <20131111182046.GA14961@gmail.com>
 <20131113181600.GA6160@amd.pavel.ucw.cz>
 <5283C7A8.2010902@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5283C7A8.2010902@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-11-13 10:40:40, H. Peter Anvin wrote:
> On 11/13/2013 10:16 AM, Pavel Machek wrote:
> > 
> > If it is not performance critical, why not use "/dev/random"
> > infrastructure?
> > 
> 
> Because it doesn't exist yet?

Would it be feasible to initialize /dev/random earlier instead of
reinventing it?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
