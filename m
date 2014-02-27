Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaB0S3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:29:42 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:63142 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaB0S3l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:29:41 -0500
MIME-Version: 1.0
In-Reply-To: <86d2i85scf.fsf@hiro.keithp.com>
References: <1393488699-6265-1-git-send-email-cworth@cworth.org>
	<20140227084936.GI3852@intel.com>
	<86d2i85scf.fsf@hiro.keithp.com>
Date: Thu, 27 Feb 2014 15:29:40 -0300
Message-ID: <CA+gsUGQO20x_2khKH-Eo4+Crnwtxx++k_9rsNMYgnwh0-eay=Q@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/dp: Allow for 5.4Gbps for Haswell.
From: Paulo Zanoni <przanoni@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
        Carl Worth <cworth@cworth.org>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-27 15:21 GMT-03:00 Keith Packard <keithp@keithp.com>:
> Ville Syrjälä <ville.syrjala@linux.intel.com> writes:
>
>> Todd already implemented 5.4Gbps support a while back. So it seems your
>> tree is a bit out of date.
>
> I didn't find it on drm-intel-fixes-2014-02-14; can you explain which
> tree it is present in?

It's on the drm-intel-next-queued branch. Please notice we recently
moved the tree from freedesktop.org/~danvet/drm-intel to
freedesktop.org/drm-intel.

http://cgit.freedesktop.org/drm-intel/commit/?h=drm-intel-next-queued&id=06ea66b6bb445043dc25a9626254d5c130093199


>
> --
> keith.packard@intel.com
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx
>



-- 
Paulo Zanoni
