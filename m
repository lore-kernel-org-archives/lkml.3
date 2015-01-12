Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbbALXPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:15:00 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:57538 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbbALXO5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:14:57 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>, John Youn <John.Youn@synopsys.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "Mian Yousaf Kaukab" <yousaf.kaukab@intel.com>,
        Yunzhi Li <lyz@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Nick Hudson <skrll@netbsd.org>
Subject: New maintainer for dwc2
Thread-Topic: New maintainer for dwc2
Thread-Index: AdAuvY537K3q4zEZTxGErlRM6KDSNw==
Date: Mon, 12 Jan 2015 23:14:54 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030484506EFD@US01WEMBX2.internal.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.184.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I will be leaving Synopsys on Friday, Jan 16th, so the dwc2 driver
will need a new maintainer.

I am recommending John Youn <johnyoun@synopsys.com> as the new
maintainer.

On the plus side, John has quite a bit of experience with the dwc2
controller, and has previous experience submitting kernel patches (for
the xhci and dwc3 drivers). And being a Synopsys employee, he will have
access to internal resources for support.

On the minus side, John has not worked directly with the in-kernel dwc2
driver until very recently, and has not done maintainer work before.

If no one has any objections, I will submit a patch to MAINTAINERS in a
couple of days making John the new dwc2 maintainer.

-- 
Paul

