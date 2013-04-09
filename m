Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935301Ab3DINVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:21:45 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:37240 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760900Ab3DINVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:21:44 -0400
Date: Tue, 9 Apr 2013 15:21:35 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Tomas Melin <tomas.melin@iki.fi>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>
Subject: Re: Re: drm/i915: new warning (regression) in 3.7.10 and 3.8.3
Message-ID: <20130409132135.GC5132@netboy>
References: <CACraW2rBMfXL_M13DD-qLvmZj55XPykEW-5qcVwViWg9XM00fA@mail.gmail.com>
 <20130409125003.GW2228@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409125003.GW2228@phenom.ffwll.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 02:50:03PM +0200, Daniel Vetter wrote:
> 
> This should be fixed with the above mentioned patch. The issue is that the
> bios fumbles around with the output configuration behind our backs, so the
> new paranoid modeset code in 3.7+ freaks out about the state mismatch
> between sw and hw.
> 
> The patch above should detect this situation and undo any bios-induced
> damage.

Even with the patch, I still am seeing the issue (in 3.8).

Thanks,
Richard
