Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab3LAQ5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 11:57:12 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:56460 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435Ab3LAQ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 11:57:08 -0500
Message-ID: <1385917025.7199.4.camel@x41.thuisdomein>
Subject: Re: [i915] WARNING: [...] drivers/gpu/drm/i915/intel_display.c:9948
 intel_get_pipe_from_connector
From: Paul Bolle <pebolle@tiscali.nl>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 01 Dec 2013 17:57:05 +0100
In-Reply-To: <CAKMK7uHRW-1OiMY44s2G9dwbbQLMUxZ4fHf=Eaf9gJ_WASpvLQ@mail.gmail.com>
References: <1385843936.10971.5.camel@x41.thuisdomein>
	 <CAKMK7uHRW-1OiMY44s2G9dwbbQLMUxZ4fHf=Eaf9gJ_WASpvLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Dec 2013 16:57:06.0185 (UTC) FILETIME=[5D955790:01CEEEB6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-01 at 10:58 +0100, Daniel Vetter wrote:
> Should be fixed with
> 
> commit 7c063c725987406d743cc7de7625ff224fab75de
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Tue Nov 26 09:13:41 2013 -0800
> 
>     drm/i915: take mode config lock around crtc disable at suspend
> 
> which is currently in drm-intel-fixes. I'll forward it early next week.

Thanks!

The WARNING is now gone during suspend and resume (having tested that
thoroughly - ie, twice). But I still see it at boot. Is there a related
fix for that WARNING during boot?


Paul Bolle

