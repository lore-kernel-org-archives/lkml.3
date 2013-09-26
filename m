Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab3IZMB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:01:57 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:63881 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab3IZMB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:01:56 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH] ARC: Use clockevents_config_and_register over
 clockevents_register_device
Thread-Topic: [PATCH] ARC: Use clockevents_config_and_register over
 clockevents_register_device
Thread-Index: AQHOuWnXV2EnR3HE+ka1d+uinqE/yA==
Date: Thu, 26 Sep 2013 12:01:49 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514E943@IN01WEMBXA.internal.synopsys.com>
References: <1380056737-3471-1-git-send-email-u.kleine-koenig@pengutronix.de>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.235]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 02:35 AM, Uwe Kleine-König wrote:
> clockevents_config_and_register is more clever and correct than doing it
> by hand; so use it.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Acked-by: Vineet Gupta <vgupta@synopsys.com>

Thx for the fix.
-Vineet
