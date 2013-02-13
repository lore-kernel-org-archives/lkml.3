Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965373Ab3BMSLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:11:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:52126 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965208Ab3BMSLc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:11:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,658,1355126400"; 
   d="scan'208";a="285298500"
From: "Luck, Tony" <tony.luck@intel.com>
To: Du Jiulun <dujiulun@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hillf Danton <dhillf@gmail.com>, Mike Galbraith <bitbucket@online.de>,
        Borislav Petkov <bp@alien8.de>
Subject: RE: Fwd: PROBLEM: Random kernel panic & system freeze when watching
 video
Thread-Topic: Fwd: PROBLEM: Random kernel panic & system freeze when
 watching video
Thread-Index: AQHN5nGrz6ubjlQZ4kOu6G67xLtDcJgyM/WAgAEG4QCAA4AqgIABii0A//+1hQCAAV3cgIA/U6KA//+xKiA=
Date: Wed, 13 Feb 2013 18:11:30 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1E0628AD@ORSMSX108.amr.corp.intel.com>
References: <CAHfmSg2akcYUwDW38g520Fwyr17E5dFDpuUMKejQCfLpQ4pnhQ@mail.gmail.com>
	<CAHfmSg3ug=64vXtsA4EA6xdKaqWRtT7qZW9AG8n92Q+pbDgQEQ@mail.gmail.com>
	<20121230094008.GA28308@x1.alien8.de>
	<CAHfmSg0O90nC3rnkZHAjO_MNjOoU1v8h-LN+jxx=0U+pz7NasQ@mail.gmail.com>
	<20121231102300.GA1701@x1.alien8.de>
	<3908561D78D1C84285E8C5FCA982C28F1C973871@ORSMSX108.amr.corp.intel.com>
	<CAHfmSg14itHxTUinrmmTq2zoFuQAVwhPCo-Mt7tTLJEiJ4B0Sw@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F1C973F99@ORSMSX108.amr.corp.intel.com>
	<CAHfmSg3-YthwNUTCmbEQox5ihjYHw9TT=WaH_fbjHHyJ+ew7eA@mail.gmail.com>
 <CAHfmSg0sxOEvLd9ASHA7uS+W2TiZ-NRR+w8snPu85iYrMFCuVA@mail.gmail.com>
In-Reply-To: <CAHfmSg0sxOEvLd9ASHA7uS+W2TiZ-NRR+w8snPu85iYrMFCuVA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -- Panic DON'T happen when the laptop is running on battery. I've
> tried over 20 battery cycles (~40 hours) doing video playbacks and the
> computer never shut down.

So my best guess is that you have a h/w problem aggravated by high temperatures.
When you are on battery the system will be saving power - which means less heat
dissipated by many components inside your laptop case.

-Tony
