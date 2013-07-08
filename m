Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3GHWbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 18:31:18 -0400
Received: from us-mx1.synaptics.com ([12.239.216.75]:61632 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3GHWbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 18:31:17 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jul 2013 18:31:17 EDT
X-PGP-Universal: processed;
	by securemail.synaptics.com on Mon, 08 Jul 2013 15:21:46 -0700
From: Christopher Heiny <Cheiny@synaptics.com>
To: Balint Czobor <czoborbalint@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] drivers: input: touchscreen: Initial support for
 SYNAPTICS_I2C_RMI touchscreen
Thread-Topic: [PATCH 1/1] drivers: input: touchscreen: Initial support for
 SYNAPTICS_I2C_RMI touchscreen
Thread-Index: AQHOe7Us/ZfYw/7hlkST96adq2j1hJlbWyuAgAAANPU=
Date: Mon, 8 Jul 2013 22:21:16 +0000
Message-ID: <BFABBC009FBA1C43B207B15FD485ABD92FDEB5DC@usw-mail3.synaptics-inc.local>
References: <1373271947-8393-1-git-send-email-czoborbalint@gmail.com>,<51DB3B13.7070805@synaptics.com>
In-Reply-To: <51DB3B13.7070805@synaptics.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.3.20.75]
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 01:25 AM, Balint Czobor wrote:
> Add initial support for Synaptics RMI over I2C based touchscreens.

This is pretty old code - it looks like a modification of patches we
submitted last year.  Is there some reason you're not basing it off the
latest checkins in synaptics-rmi4 branch of  Dmitry's input tree?

