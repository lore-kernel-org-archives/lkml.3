Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051AbaLPGmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 01:42:17 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:64734 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaLPGmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 01:42:16 -0500
Date: Tue, 16 Dec 2014 07:42:11 +0100
From: Heinz Diehl <htd+ml@fritha.org>
To: linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [Regression] 83f45fc turns machine's screen off
Message-ID: <20141216064211.GA5762@fritha.org>
References: <CA+i8gKK0sj55s-Gk8Y36KM4yBFLvLotffbSodjH5Gsd_yxd5Sg@mail.gmail.com>
 <CAKMK7uGa_dHnie8EACcX0mQvc-uGpsgQHjWGN_obxPa3O6SJbw@mail.gmail.com>
 <CA+i8gKKGBviLBaS8b=swqv2OWgh2Uc+m-TT8LVYcPehcYd903A@mail.gmail.com>
 <CA+i8gKJPPPUXrxY5q+81xZG91azygoUb27R_Wid3GTpb3-1-rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+i8gKJPPPUXrxY5q+81xZG91azygoUb27R_Wid3GTpb3-1-rw@mail.gmail.com>
Organization: private site
OpenPGP: id=60F4A92C; url=http://www.fritha.org/htd.asc;
 preference=signencrypt
User-Agent: Mutt/1.5.23+16 (39d3ddb56d34) (2014-03-12)
X-Provags-ID: V03:K0:lFYFP0fAAMKpJRwHn20sKaglEQlSnz6sA4CTcu4CbInVE9esOEc
 f8xO6OX6p3hrP2F6YT8pSnv37wwwz3nDT3vEkpgBAhDG2tB3rGBbpTv7cNMIFL5N2l/sEvJ
 QvOAvAVEHgokoN8QYWbP/Epr6K0rPKOn3zKs/ZIAUQGPXCc1DzfTzMGPqP7wyYDIw045N2S
 0NEqvUHlmOI4dBw2Ctr3A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.12.2014, Emmanuel Benisty wrote: 

> >>> The following commit permanently turns my screen off when x server is
> >>> started (i3 330M Ironlake):
> >>>
> >>>     [83f45fc360c8e16a330474860ebda872d1384c8c] drm: Don't grab an fb
> >>> reference for the idr
> >>>
> >>> Reverting this commit fixed the issue.

Haven't seen your mail until now. Seems to be the same bug that I'm encountering.

https://bugs.freedesktop.org/show_bug.cgi?id=87330
https://lkml.org/lkml/2014/12/14/26

