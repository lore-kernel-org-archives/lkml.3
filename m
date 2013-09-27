Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3I0JF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 05:05:28 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:64956 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab3I0JFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 05:05:08 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ARC: Use clockevents_config_and_register over
 clockevents_register_device
Thread-Topic: [PATCH] ARC: Use clockevents_config_and_register over
 clockevents_register_device
Thread-Index: AQHOuWnXV2EnR3HE+ka1d+uinqE/yA==
Date: Fri, 27 Sep 2013 09:00:20 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514EBA0@IN01WEMBXA.internal.synopsys.com>
References: <1380056737-3471-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <C2D7FE5348E1B147BCA15975FBA2307514E943@IN01WEMBXA.internal.synopsys.com>
 <20130927081738.GL16106@pengutronix.de>
 <C2D7FE5348E1B147BCA15975FBA2307514EB8B@IN01WEMBXA.internal.synopsys.com>
 <20130927085203.GM16106@pengutronix.de>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 02:22 PM, Uwe Kleine-König wrote:
> I still have a few such fixes in the queue, but as they are all
> independant of each other I think it would be best if you took it.

Queued up for 3.12-rc3

