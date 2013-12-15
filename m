Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3LOMT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 07:19:59 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60814 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab3LOMTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 07:19:50 -0500
Date: Sun, 15 Dec 2013 13:19:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        David Airlie <airlied@linux.ie>, Jerome Glisse <jglisse@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] radeon_pm: fix oops in hwmon_attributes_visible() and
 radeon_hwmon_show_temp_thresh()
Message-ID: <20131215121948.GA4361@pd.tnic>
References: <20131212232557.GA2203@swordfish>
 <A3397C8B8B789E45844E7EC5DEAD89D030AA1DFB@satlexdag05.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D030AA1DFB@satlexdag05.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 11:29:41PM +0000, Deucher, Alexander wrote:
> Fix is already queued in my next -fixes pull.  Thanks!

I just hit this too so +1.

Btw, if Linus cuts -rc4 tonight and your pull request doesn't make it
in before then, we probably should warn people using radeon and testing
-rcs that they need this fix too.

Dunno, just a heads-up I think.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
