Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab3KWNvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 08:51:54 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57139 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab3KWNvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 08:51:53 -0500
Date: Sat, 23 Nov 2013 14:51:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] i915, debugfs: Fix uninitialized warning
Message-ID: <20131123135150.GD24148@pd.tnic>
References: <1385048986-14478-1-git-send-email-bp@alien8.de>
 <CAFLxGvzcAYwdcdNmZt4stTSCueRmStFYt+MqvNAS3BJX7CnUoQ@mail.gmail.com>
 <20131121162535.GK26009@pd.tnic>
 <20131122150959.GD10036@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131122150959.GD10036@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 05:09:59PM +0200, Ville Syrjälä wrote:
> IIRC this warning was there for me too on gcc 4.6, but it disappeared
> on gcc 4.7, which is why I decided not to send a patch for it.

A disappearing and reappearing warning happened to me recently too. I
attributed that to compiler upgrades. With this it will shut up for
good. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
