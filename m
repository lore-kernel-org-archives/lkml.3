Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3BDToG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:44:06 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:58832 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755979Ab3BDToD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:44:03 -0500
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2013 14:44:00 EST
From: Bing Zhao <bzhao@marvell.com>
To: Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Avinash Patil <patila@marvell.com>, Kiran Divekar <dkiran@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 4 Feb 2013 11:43:56 -0800
Subject: RE: [ 014/128] mwifiex: wakeup and stop multiple tx queues in
 net_device
Thread-Topic: [ 014/128] mwifiex: wakeup and stop multiple tx queues in
 net_device
Thread-Index: Ac4CHnVhH3Myc481T7u52WDPVpNmmgA8Q4oA
Message-ID: <477F20668A386D41ADCC57781B1F70430D1432F5B8@SC-VEXCH1.marvell.com>
References: <20130203144644.035172954@decadent.org.uk>
 <20130203144645.292616915@decadent.org.uk>
In-Reply-To: <20130203144645.292616915@decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Avinash Patil <patila@marvell.com>
> 
> commit bbea3bc432dc5c08d09ca5c80afdd82515470688 upstream.

This patch is not for stable kernel.

Thanks,
Bing

> 
> replace single queue function calls with equivalent multiple queue
> functions. Wakeup queue and stop queue calls are guarded by spin lock.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Kiran Divekar <dkiran@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/net/wireless/mwifiex/init.c      |   40 ++++++++++++++++++++++++++++++
>  drivers/net/wireless/mwifiex/main.c      |   11 ++++----
>  drivers/net/wireless/mwifiex/main.h      |    9 +++++++
>  drivers/net/wireless/mwifiex/sta_event.c |    6 ++---
>  drivers/net/wireless/mwifiex/sta_ioctl.c |    4 +--
>  drivers/net/wireless/mwifiex/txrx.c      |    5 ++--
>  6 files changed, 63 insertions(+), 12 deletions(-)

