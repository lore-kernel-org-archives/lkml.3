Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbaGBIx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:53:28 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:52392 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205AbaGBIxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:53:25 -0400
Message-ID: <1404291203.12021.18.camel@x220>
Subject: Re: drm: i915: "plane B assertion failure, should be off on pipe B
 but is still active"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Jul 2014 10:53:23 +0200
In-Reply-To: <87egy5h1yz.fsf@intel.com>
References: <1404140703.2978.13.camel@x41> <87egy5h1yz.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2014 08:53:23.0646 (UTC) FILETIME=[14CA15E0:01CF95D3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-01 at 12:17 +0300, Jani Nikula wrote:
> This does not ring any bells to me (but that doesn't prove anything). A
> bisect result would be awesome.

Too bad.

Unless someone else has a better idea I hope to start bisecting one of
these days (that might take quite some time, especially since I can't
yet narrow the bisect to changes in drivers/gpu/drm/i915/, can I?).
Don't expect results before v3.16-rc4.

Feel free to remind me if I stay silent on this subject for too long.


Paul Bolle

