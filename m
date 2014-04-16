Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaDPIcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:32:35 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:51269 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaDPIcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:32:32 -0400
Message-ID: <534E401D.8030805@gmail.com>
Date: Wed, 16 Apr 2014 11:32:29 +0300
From: Kertesz Laszlo <laszlo.kertesz@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:28.0) Gecko/20100101 Firefox/28.0 SeaMonkey/2.25
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
CC: Alex Deucher <alexdeucher@gmail.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: 15-rc1: radeon modesetting fails
References: <20140415070204.GA4806@pd.tnic> <534CFBD7.3070604@amd.com> <20140415120740.GA8306@nazgul.tnic> <CADnq5_PpPa_fbm=1KH__q-W2OuvfoHr2wquimQ8TCq=xwwYq_Q@mail.gmail.com> <534D677C.6080407@gmail.com> <20140415172702.GC4826@pd.tnic> <534D743B.8010705@gmail.com> <20140415180735.GG4826@pd.tnic> <534DA97E.8070505@gmail.com> <A3397C8B8B789E45844E7EC5DEAD89D03ECB1D65@satlexdag05.amd.com> <20140415224850.GA12892@pd.tnic>
In-Reply-To: <20140415224850.GA12892@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Tue, Apr 15, 2014 at 10:32:56PM +0000, Deucher, Alexander wrote:
>> Turning off modesetting basically disables the driver.
>
> Well, in my case, I was using the radeon.modeset=0 variant to rule out
> issues in x.org. And in my case x.org did start still, albeit with a
> jacked-up resolution.
>
> But in Laszlo's case, x.org gets "puzzled" too.
>

Maybe your distro's xorg has some generic vga fallback method. I am not aware that mine (Debian Testing) has one.
BTW I use Debian Testing (xfce) and glamor (compiled from git) so i need a specific xorg.conf.

