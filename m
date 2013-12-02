Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3LBSCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:02:00 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:52960 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152Ab3LBSB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:01:56 -0500
Message-ID: <1386007314.9830.2.camel@x41.thuisdomein>
Subject: Re: [PATCH] drm/i915: Take modeset locks around
 intel_modeset_setup_hw_state()
From: Paul Bolle <pebolle@tiscali.nl>
To: Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Mon, 02 Dec 2013 19:01:54 +0100
In-Reply-To: <20131202121219.GN10036@intel.com>
References: <CAKMK7uE_L8cqyYk6mQ4paXeh2m7tmoMXRv_KxoAeBq9MEAnFqw@mail.gmail.com>
	 <1385975286-25392-1-git-send-email-ville.syrjala@linux.intel.com>
	 <1385978429.2972.8.camel@x41.thuisdomein>
	 <20131202121219.GN10036@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Dec 2013 18:01:55.0267 (UTC) FILETIME=[9611E930:01CEEF88]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-02 at 14:12 +0200, Ville Syrjälä wrote:
> On Mon, Dec 02, 2013 at 11:00:29AM +0100, Paul Bolle wrote: 
> > I assume I need to test this, on top of 7c063c725987 ("drm/i915: take
> > mode config lock around crtc disable at suspend"), to see if this makes
> > the WARNING that I currently see at boot go away?
> 
> Yeah that would be nice.

A grand total of one boot suggests that this patch really makes the
v3.13+ WARNING go away at boot too. Should I test more thoroughly?


Paul Bolle

