Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3JWQsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:48:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:58001 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab3JWQro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 12:47:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="397428184"
From: "Boie, Andrew P" <andrew.p.boie@intel.com>
To: Guenter Roeck <linux@roeck-us.net>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mmarek@suse.cz" <mmarek@suse.cz>
Subject: RE: [PATCH 1/1] x86: boot: support minigzip bzImage compression
Thread-Topic: [PATCH 1/1] x86: boot: support minigzip bzImage compression
Thread-Index: AQHOz2pV0LFDi52eiUWQWG1/lb50mZoB44CAgAApEQCAAGoR9Q==
Date: Wed, 23 Oct 2013 16:47:38 +0000
Message-ID: <2E57EB624252DB47AFBC064A9AFBA98064B75AF3@ORSMSX104.amr.corp.intel.com>
References: <1382476041-1115-1-git-send-email-andrew.p.boie@intel.com>
 <1382476041-1115-2-git-send-email-andrew.p.boie@intel.com>
 <e7a2d995-e90f-4912-a0b9-4cf5725b246b@email.android.com>,<52673A1E.60005@roeck-us.net>
In-Reply-To: <52673A1E.60005@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.19.9.41]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Guenter Roeck [linux@roeck-us.net]
> Or just change the build system to have /bin/gzip point to minigzip if so
> desired. I have done the same to replace it with pigz.
> Debian/Ubuntu provides the update-alternatives command for that
> purpose. If that is not available, just hard-link it.

Android minigzip and gzip unfortunately don't have the same command line syntax. Before I wrote this patch I had a horrible hack in place involving a shell script named "gzip" that called minigzip internally.

Andrew