Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3I0I1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:27:12 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:50930 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3I0I1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:27:08 -0400
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
Date: Fri, 27 Sep 2013 08:26:58 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514EB8B@IN01WEMBXA.internal.synopsys.com>
References: <1380056737-3471-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <C2D7FE5348E1B147BCA15975FBA2307514E943@IN01WEMBXA.internal.synopsys.com>
 <20130927081738.GL16106@pengutronix.de>
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

On 09/27/2013 01:47 PM, Uwe Kleine-König wrote:
> On Thu, Sep 26, 2013 at 12:01:49PM +0000, Vineet Gupta wrote:
>> On 09/25/2013 02:35 AM, Uwe Kleine-König wrote:
>>> clockevents_config_and_register is more clever and correct than doing it
>>> by hand; so use it.
>>>
>>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> Acked-by: Vineet Gupta <vgupta@synopsys.com>
> Thanks for the ack, but I expected that it will be you who takes that
> patch. Am I wrong? Who will take it instead?

Well that really depends - if there's a series of such fixes, people generally
route it thru mm or some such.
But, sure I can take it.

Thx again,
-Vineet


