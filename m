Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaG3MzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:55:19 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:63557 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaG3MzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:55:17 -0400
Date: Wed, 30 Jul 2014 14:55:23 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Dave Airlie <airlied@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v5 00/11] Add DRM for stih4xx platforms
Message-ID: <20140730125523.GP4747@phenom.ffwll.local>
Mail-Followup-To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Dave Airlie <airlied@gmail.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <CAF6AEGsAtqCjrvrgcXmOY0nie89ppFHBcRPtt36ESHWBNqobTg@mail.gmail.com>
 <CA+M3ks4BU3MTaeCeMPbu8LqW=H27ZAdF-qZLUiG3UXJzbA89Fw@mail.gmail.com>
 <CA+M3ks5osUkkEY64t=M1zEp7DA5rn+MxxqiJhQm5QiEFUPBL+A@mail.gmail.com>
 <CA+M3ks7-ZHghELcRHDiFNbubDZ2DRQPDh2bKKzhsu4EcA0Tzcg@mail.gmail.com>
 <CAF6AEGupwP4aq7EG2SdRUAwy-dzab7fVd2SSoHfGpX8o6yR+WQ@mail.gmail.com>
 <CAPM=9tyKWbffCrUP+3VETEcqAvMG-5+wkW7Rg09BGDnbO=jsBw@mail.gmail.com>
 <CA+M3ks7dfE9nfH6J++fB897PJ407amuxU_g6As-xzPzddTgArw@mail.gmail.com>
 <CAPM=9twxj3KsdqqdeP2S_TyMUDHs5aYHExWC3FyTm=+n153Liw@mail.gmail.com>
 <CA+M3ks5A_aacyDjcAGRPNw1xw82YQJJGwHkZQeY8zvtd6=t1BQ@mail.gmail.com>
 <CA+M3ks5=s33dZ_uz4G+sK+Ckv7CxH11fhDpYG8JAAkHb5kh66Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+M3ks5=s33dZ_uz4G+sK+Ckv7CxH11fhDpYG8JAAkHb5kh66Q@mail.gmail.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 12:43:33PM +0200, Benjamin Gaignard wrote:
> I have push two additional patches on drm_kms_for_next-v7 branch to
> make the driver build as a module:
> - "gpu: drm: export drm_sysfs_connector_{add,remove} function"

Nope, you're using the wrong functions. Instead you should use
drm_connector_register/unregister. Please don't just export randome
functions without digging into the history a bit.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
