Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbaDHICv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:02:51 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:63970 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbaDHICq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:02:46 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <CAMVG2suG7ysnci25Cy_+fzvQ8r_R9O2nCuVZf=Zw9t5ZvEOSLQ@mail.gmail.com>
References: <CAMVG2sti6EMQXw5xyNp-wkq0nGz4zVgz1p7AO48Kb1_zYk8K0w@mail.gmail.com>
	<878urg9ttv.fsf@intel.com>
	<CAMVG2suG7ysnci25Cy_+fzvQ8r_R9O2nCuVZf=Zw9t5ZvEOSLQ@mail.gmail.com>
Date: Tue, 8 Apr 2014 10:02:46 +0200
Message-ID: <CAKMK7uE=F_T9M6L7U7t7xeJLdJXbhYF+MbvrsAeYeSqCC=hKKA@mail.gmail.com>
Subject: Re: [Intel-gfx] i915 DVI resolution regression (3.13.7+)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Daniel J Blueman <daniel@quora.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 9:32 AM, Daniel J Blueman <daniel@quora.org> wrote:
> I am using a dual-link DVI-D to DVI-D cable to this monitor, since I
> previously couldn't get 2560x1440 via HDMI.
>
> If it isn't this commit, then it may be another commit in 3.13.7,
> albeit it feels less likely.

Before we go on a wild goose chase, can you please confirm your
suspicion with a revert?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
