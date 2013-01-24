Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3AXA3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 19:29:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:37046 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab3AXA3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:29:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="247695860"
From: "Su, Xuemin" <xuemin.su@intel.com>
To: Daniel Vetter <daniel@ffwll.ch>
CC: "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "He, Bo" <bo.he@intel.com>
Subject: RE: [PATCH V2 RESEND] drm_crtc: check if fb_create return NULL
Thread-Topic: [PATCH V2 RESEND] drm_crtc: check if fb_create return NULL
Thread-Index: AQHN+RfYTM6B2JdxT0+KNrbIp+OCAJhWJruAgAF5mjA=
Date: Thu, 24 Jan 2013 00:27:36 +0000
Message-ID: <CDD08C147402274194A8DDD9DBEF5593411BF4@SHSMSX101.ccr.corp.intel.com>
References: <1358911167.18561.20.camel@suxuemin.sh.intel.com>
 <20130123095337.GQ31870@phenom.ffwll.local>
In-Reply-To: <20130123095337.GQ31870@phenom.ffwll.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
>From: Daniel Vetter [mailto:daniel.vetter@ffwll.ch] On Behalf Of Daniel Vetter
>Sent: Wednesday, January 23, 2013 5:54 PM
>To: Su, Xuemin
>Cc: airlied@linux.ie; dri-devel@lists.freedesktop.org; linux-kernel@vger.kernel.org; yanmin_zhang@linux.intel.com; He, Bo
>Subject: Re: [PATCH V2 RESEND] drm_crtc: check if fb_create return NULL

>Imo just BUG_ON(!fb); and call it a day. Makes it pretty clear what's expected of the drivers.
>-Daniel

Thanks, I will upload PATCH V3.
Xuemin

