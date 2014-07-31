Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaGaFJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:09:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:31298 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaGaFJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:09:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,769,1400050800"; 
   d="scan'208";a="551657757"
Date: Thu, 31 Jul 2014 13:09:33 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [LKP] [drm/i915] WARNING: CPU: 3 PID: 248 at
 drivers/gpu/drm/i915/intel_pm.c:6427 check_power_well_state+0x60/0x90
 [i915]()
Message-ID: <20140731050933.GB9386@aaronlu.sh.intel.com>
References: <53d70753.0iBGqYd97TVbYboG%fengguang.wu@intel.com>
 <53D70A36.4030907@intel.com>
 <20140729101430.GT27580@intel.com>
 <CAKMK7uHDkeWyvG-xUEfhZXmo5a+RiBt+huT1My2zG6ibePNuFw@mail.gmail.com>
 <53D8565E.3080707@intel.com>
 <CAKMK7uHAH5is3+CGOxTimxjx2x1auYf4gXAzWjkuTdB2mRkk-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uHAH5is3+CGOxTimxjx2x1auYf4gXAzWjkuTdB2mRkk-Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:40:05AM +0200, Daniel Vetter wrote:
> On Wed, Jul 30, 2014 at 4:20 AM, Aaron Lu <aaron.lu@intel.com> wrote:
> > On 07/29/2014 07:10 PM, Daniel Vetter wrote:
> >> On Tue, Jul 29, 2014 at 12:14 PM, Ville Syrjälä
> >> <ville.syrjala@linux.intel.com> wrote:
> >>> On Tue, Jul 29, 2014 at 10:43:02AM +0800, Aaron Lu wrote:
> >>>> FYI, we noticed the below changes on
> >>>>
> >>>> git://people.freedesktop.org/~danvet/drm colder-fusion
> >>>
> >>> Does it happen on -nightly too?
> >>
> >> git://anongit.freedesktop.org/drm-intel
> >
> > With this git tree, do we still need to watch the old one? Or they serve
> > different purpose?
> 
> The old one is just my private repo, never contained official
> branches. The one I've given is the official drm-intel git for
> upstream.

Thanks for the clarification, we have removed your private repo.

Regards,
Aaron
