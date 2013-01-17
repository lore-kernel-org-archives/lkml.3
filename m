Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3AQI6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:58:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58288 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab3AQI6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:58:54 -0500
Date: Thu, 17 Jan 2013 09:58:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>, Kirill Smelkov <kirr@mns.spb.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Tell the world we gave up on pushing CC_OPTIMIZE_FOR_SIZE
Message-ID: <20130117085851.GC30700@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dave Jones <davej@redhat.com>, Kirill Smelkov <kirr@mns.spb.ru>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1351856461-3662-1-git-send-email-kirr@mns.spb.ru>
 <20121122081041.GA380@tugrik.mns.mnsspb.ru>
 <20121124001040.GA29164@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121124001040.GA29164@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 07:10:40PM -0500, Dave Jones wrote:
> FWIW, we gave up using this in Fedora quite a few releases back
> because we kept finding workloads that it truly sucked on. For code
> that is quite bloaty and not particularly performance critical, maybe
> we could move -Os to individual directories.

FWIW, one more minor thing speaking against -Os: it warns worngly about
an unitialized variable while -O2 doesn't:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=55759

Maybe there's more stuff wrong with it...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
