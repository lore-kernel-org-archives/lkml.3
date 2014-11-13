Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669AbaKMRro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:47:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60132 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296AbaKMRrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:47:42 -0500
Date: Thu, 13 Nov 2014 18:47:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, intel-gfx@lists.freedesktop.org,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>, Ingo Molnar <mingo@kernel.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] x86: Use clwb in drm_clflush_virt_range
Message-ID: <20141113174734.GF14070@pd.tnic>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
 <1415731396-19364-7-git-send-email-ross.zwisler@linux.intel.com>
 <5464220D.6090204@amacapital.net>
 <20141113112017.GA14416@pd.tnic>
 <CALCETrV2E-LBHLTV6zJ=nfw8ijjV8VZoYAinXdg9ZaOryfqquw@mail.gmail.com>
 <20141113171133.GD14070@pd.tnic>
 <20141113173354.GT10649@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141113173354.GT10649@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 07:33:54PM +0200, Ville Syrjälä wrote:
> We use it both ways in i915. So please don't break it.

Haha, we started from Intel with Ross' patch and made a full circle
back. Maybe you guys should talk about it.

LOL. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
