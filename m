Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaDQQ15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:27:57 -0400
Received: from infra.glanzmann.de ([88.198.249.254]:34924 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaDQQ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:27:48 -0400
Date: Thu, 17 Apr 2014 18:27:46 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        alexander.deucher@amd.com, christian.koenig@amd.com,
        daniel.vetter@ffwll.ch, LKML <linux-kernel@vger.kernel.org>
Subject: Re: REGRESSION: OOPS: Intel Corporation Core Processor Integrated
 Graphics Controller, Linux HEAD when powering off internal Laptop display on
 t410s and extending and rotating external screen
Message-ID: <20140417162746.GA23175@glanzmann.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	alexander.deucher@amd.com, christian.koenig@amd.com,
	daniel.vetter@ffwll.ch, LKML <linux-kernel@vger.kernel.org>
References: <20140417065811.GA9319@glanzmann.de>
 <877g6ogie7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877g6ogie7.fsf@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Jani,

> Hi Thomas, please bisect, it's likely the quickest way to root cause
> this. (Google for "git bisect kernel" for a bunch of guides on the
> topic
> if you're not familiar with bisect.)

I switched my location and no longer have an external monitor with
display port available, if I do, I'll do the bisect but currently the
problem does no longer show up without an external monitor attached.

Cheers,
        Thomas
