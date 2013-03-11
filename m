Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3CKUZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:25:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51583 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab3CKUZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:25:45 -0400
Date: Mon, 11 Mar 2013 21:25:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: jeffrey.t.kirsher@intel.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: e1000e + suspend, 3.9-rc2
Message-ID: <20130311202537.GF5000@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	jeffrey.t.kirsher@intel.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Jiri Slaby <jslaby@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	e1000-devel@lists.sourceforge.net,
	Bruce Allan <bruce.w.allan@intel.com>
References: <20130311191936.GD5000@pd.tnic>
 <513E355C.4000204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <513E355C.4000204@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:49:48PM -0700, Jeff Kirsher wrote:
> No, the patches have not made it into Linus's tree yet. They are in
> David Miller's net tree, and he just sent a pull request to Linus this
> morning. So expect them to be in 3.9-rc3.

You mean this pull request:

commit 0cb77508252e2d0e00c5ec7e57b4be9b3f7eb24d
Merge: ffb6a445e7cd 9026c4927254
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Mar 11 07:51:59 2013 -0700

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
    
    Pull networking fixes from David Miller:

?

Yeah, it is already upstream. And yeah, it did trigger with it.

$ git describe
v3.9-rc2-112-g7c6baa304b84

But it somehow doesn't trigger with that same kernel anymore so I'll
consider it a glitch and watch it over the next days.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
