Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab3IJKLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 06:11:12 -0400
Received: from mailout10.t-online.de ([194.25.134.21]:37625 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab3IJKLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 06:11:09 -0400
Message-ID: <522EF02C.1080403@t-online.de>
Date: Tue, 10 Sep 2013 12:10:52 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Imre Deak <imre.deak@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915/tv: clear adjusted_mode.flags
References: <522EDB3D.7040504@t-online.de> <1378806270-18132-1-git-send-email-daniel.vetter@ffwll.ch>
In-Reply-To: <1378806270-18132-1-git-send-email-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: GEjRL+ZDYh67IqP--uHG674FeVzFNrm0QTJLZy7PXmkpP0TR9y3NtTZD06OJl4eQqH
X-TOI-MSGID: b87a1a49-c3c9-4eef-8719-7f50c87e0159
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.09.2013 11:44, Daniel Vetter wrote:

Thanks. Combined with your two patches and Jesse Barnes' patch
"add early quirk for reserving Intel graphics stolen memory v5",
current linux master branch works fine on i915GM hardware now.

cu,
  Knut

