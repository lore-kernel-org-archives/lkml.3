Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaDOWsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:48:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45555 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbaDOWsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:48:53 -0400
Date: Wed, 16 Apr 2014 00:48:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: Kertesz Laszlo <laszlo.kertesz@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: 15-rc1: radeon modesetting fails
Message-ID: <20140415224850.GA12892@pd.tnic>
References: <20140415070204.GA4806@pd.tnic>
 <534CFBD7.3070604@amd.com>
 <20140415120740.GA8306@nazgul.tnic>
 <CADnq5_PpPa_fbm=1KH__q-W2OuvfoHr2wquimQ8TCq=xwwYq_Q@mail.gmail.com>
 <534D677C.6080407@gmail.com>
 <20140415172702.GC4826@pd.tnic>
 <534D743B.8010705@gmail.com>
 <20140415180735.GG4826@pd.tnic>
 <534DA97E.8070505@gmail.com>
 <A3397C8B8B789E45844E7EC5DEAD89D03ECB1D65@satlexdag05.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D03ECB1D65@satlexdag05.amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:32:56PM +0000, Deucher, Alexander wrote:
> Turning off modesetting basically disables the driver.

Well, in my case, I was using the radeon.modeset=0 variant to rule out
issues in x.org. And in my case x.org did start still, albeit with a
jacked-up resolution.

But in Laszlo's case, x.org gets "puzzled" too.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
