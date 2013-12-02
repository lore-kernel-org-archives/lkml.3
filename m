Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3LBSF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:05:28 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:64115 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751181Ab3LBSF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:05:27 -0500
Message-ID: <1386007525.9830.4.camel@x41.thuisdomein>
Subject: Re: [i915] WARNING: [...] drivers/gpu/drm/i915/intel_display.c:9948
 intel_get_pipe_from_connector
From: Paul Bolle <pebolle@tiscali.nl>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 02 Dec 2013 19:05:25 +0100
In-Reply-To: <CAKMK7uE=Wr95XM85XVS1nT_8cV4e1Z_SubSVjQyP8BuLz-bTQg@mail.gmail.com>
References: <1385843936.10971.5.camel@x41.thuisdomein>
	 <CAKMK7uHRW-1OiMY44s2G9dwbbQLMUxZ4fHf=Eaf9gJ_WASpvLQ@mail.gmail.com>
	 <1385917025.7199.4.camel@x41.thuisdomein>
	 <CAKMK7uE_L8cqyYk6mQ4paXeh2m7tmoMXRv_KxoAeBq9MEAnFqw@mail.gmail.com>
	 <1385978027.2972.3.camel@x41.thuisdomein>
	 <CAKMK7uE=Wr95XM85XVS1nT_8cV4e1Z_SubSVjQyP8BuLz-bTQg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Dec 2013 18:05:25.0475 (UTC) FILETIME=[135D1B30:01CEEF89]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-02 at 15:23 +0100, Daniel Vetter wrote:
> On Mon, Dec 2, 2013 at 10:53 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > This generated quite a bit of debug messages so I only copied the
> > WARNING and the drm (related) messages immediately preceding it. Please
> > feel free to prod again if that's insufficient.
> 
> Yeah, the beginning of the drm message would are wanted since I need
> to know what exactly your hardware claims to support ;-)
> 
> But the backtrace confirms my first hunch for now ... Just want to
> confirm before sending out a patch with commit message.

It seems Ville's patch ( https://lkml.org/lkml/2013/12/2/77 ) does the
trick. Do you still need the additional info?


Paul Bolle

