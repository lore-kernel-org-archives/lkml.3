Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3AaAz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 19:55:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:38079 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab3AaAzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:55:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,572,1355126400"; 
   d="scan'208";a="250527771"
From: "Su, Xuemin" <xuemin.su@intel.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
CC: "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "He, Bo" <bo.he@intel.com>
Subject: RE: [PATCH V3] drm_crtc: check if fb_create return NULL
Thread-Topic: [PATCH V3] drm_crtc: check if fb_create return NULL
Thread-Index: AQHN+cp64wPr1K2oZ0urPhpEh4jDvphXoM4AgACO+k+ACnYAUA==
Date: Thu, 31 Jan 2013 00:55:21 +0000
Message-ID: <CDD08C147402274194A8DDD9DBEF5593414954@SHSMSX101.ccr.corp.intel.com>
References: <1358987804.18561.22.camel@suxuemin.sh.intel.com>
 <87bocfugln.fsf@intel.com> <1359017171.18561.29.camel@suxuemin.sh.intel.com>
 <878v7juf2v.fsf@intel.com>
In-Reply-To: <878v7juf2v.fsf@intel.com>
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
From: Jani Nikula [mailto:jani.nikula@linux.intel.com] 
Sent: Thursday, January 24, 2013 5:05 PM
To: Su, Xuemin
Cc: airlied@linux.ie; dri-devel@lists.freedesktop.org; linux-kernel@vger.kernel.org; yanmin_zhang@linux.intel.com; He, Bo
Subject: Re: [PATCH V3] drm_crtc: check if fb_create return NULL

>Ah, sorry, never mind, I missed Daniel's comment. The benefit of the
>BUG_ON() is making it clear what's expected of the drivers.

>Reviewed-by: Jani Nikula <jani.nikula@intel.com>

Do you think this patch is still needed?
Currently I fix a buggy function radeon_user_framebuffer_create() which returns NULL and patch is added to 3.7-stable tree.
Do you think it's also needed to do something in drm_mode_addfb()?
Thanks.
