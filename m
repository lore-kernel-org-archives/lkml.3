Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaBGL2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:28:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45497 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbaBGL2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:28:14 -0500
Date: Fri, 7 Feb 2014 12:28:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Imre Deak <imre.deak@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: intel_sdvo_init: trying to register non-static key
Message-ID: <20140207112809.GG24395@pd.tnic>
References: <20140207093205.GA24395@pd.tnic>
 <87d2iz18vi.fsf@intel.com>
 <1391771542.5669.6.camel@intelbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1391771542.5669.6.camel@intelbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 01:12:22PM +0200, Imre Deak wrote:
> On Fri, 2014-02-07 at 13:04 +0200, Jani Nikula wrote:
> > Imre, is this the same i2c_del_adapter issue you're looking at? Any
> > patches to try yet?
> 
> It looks like the same issue yes. The following patch fixed it for me:
> 
> http://patchwork.freedesktop.org/patch/18698/
> 
> I'm working on an improved version of this, but the main thing - to
> remove the connector's sysfs entries before actually destroying the
> encoder and connector objects - will remain the same as in the above
> patch.

You could shoot the final version my way so that I give it a run too.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
