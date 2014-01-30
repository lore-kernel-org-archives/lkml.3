Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaA3TFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:05:19 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49256 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaA3TFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:05:17 -0500
Date: Thu, 30 Jan 2014 14:05:13 -0500
From: Tejun Heo <tj@kernel.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, Wolfram Sang <wsa@the-dreams.de>,
        intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Subject: Re: kernfs oops with i915+i2c_core in 3.14 merge window
Message-ID: <20140130190513.GB16260@htj.dyndns.org>
References: <CA+5PVA4Oj7XOZSEYqXGE7ZPVVK1oEHEc-w_DniCediWGVhrmhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4Oj7XOZSEYqXGE7ZPVVK1oEHEc-w_DniCediWGVhrmhQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 02:03:18PM -0500, Josh Boyer wrote:
> Hi All,
> 
> I'm seeing the oops below on my MacBookPro 10,2 machine using i915
> graphics.  It's after the DRM merge for 3.14 ( v3.13-10094-g9b0cd30) ,
> but we seem to have one report[1] of this happening well before that,
> in v3.13-3260-g03d11a0 as well.  Does anyone have a clue what is going
> on here?
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1055105

Should be fixed by the following patch which is already queued.

 http://lkml.kernel.org/g/20140129170403.GJ30842@htj.dyndns.org

Thanks.

-- 
tejun
