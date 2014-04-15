Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaDOR1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:27:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43197 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbaDOR1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:27:06 -0400
Date: Tue, 15 Apr 2014 19:27:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kertesz Laszlo <laszlo.kertesz@gmail.com>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: 15-rc1: radeon modesetting fails
Message-ID: <20140415172702.GC4826@pd.tnic>
References: <20140415070204.GA4806@pd.tnic>
 <534CFBD7.3070604@amd.com>
 <20140415120740.GA8306@nazgul.tnic>
 <CADnq5_PpPa_fbm=1KH__q-W2OuvfoHr2wquimQ8TCq=xwwYq_Q@mail.gmail.com>
 <534D677C.6080407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <534D677C.6080407@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 08:08:12PM +0300, Kertesz Laszlo wrote:
> Same issue here (integrated Radeon HD 8570D), 64 bit Debian, kernel,
> drm, mesa built from git today. I see nothing and receive no message
> on the monitors (i have 2 identical ones, one on the DVI andother on
> HDMI), but the system is running fine otherwise it seems, i could
> switch to the console, log in and reboot blindly. Cristian's branch
> didnt help.
>
> Reverting 32167016076f714f0e35e287fbead7de0f1fb179 did work.

Does booting with "radeon.modeset=0" help?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
