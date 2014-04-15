Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaDOSCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:02:39 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:33052 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaDOSCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:02:37 -0400
Message-ID: <534D743B.8010705@gmail.com>
Date: Tue, 15 Apr 2014 21:02:35 +0300
From: Kertesz Laszlo <laszlo.kertesz@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:28.0) Gecko/20100101 Firefox/28.0 SeaMonkey/2.25
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: 15-rc1: radeon modesetting fails
References: <20140415070204.GA4806@pd.tnic> <534CFBD7.3070604@amd.com> <20140415120740.GA8306@nazgul.tnic> <CADnq5_PpPa_fbm=1KH__q-W2OuvfoHr2wquimQ8TCq=xwwYq_Q@mail.gmail.com> <534D677C.6080407@gmail.com> <20140415172702.GC4826@pd.tnic>
In-Reply-To: <20140415172702.GC4826@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Tue, Apr 15, 2014 at 08:08:12PM +0300, Kertesz Laszlo wrote:
>> Same issue here (integrated Radeon HD 8570D), 64 bit Debian, kernel,
>> drm, mesa built from git today. I see nothing and receive no message
>> on the monitors (i have 2 identical ones, one on the DVI andother on
>> HDMI), but the system is running fine otherwise it seems, i could
>> switch to the console, log in and reboot blindly. Cristian's branch
>> didnt help.
>>
>> Reverting 32167016076f714f0e35e287fbead7de0f1fb179 did work.
>
> Does booting with "radeon.modeset=0" help?
>
Honestly didnt try that but i assume yes, since the screens go black when it should change resolution.

-- 
O zi buna,
Kertesz Laszlo
