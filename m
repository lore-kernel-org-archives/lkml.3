Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3GACSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 22:18:47 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:52411 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab3GACSq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 22:18:46 -0400
From: Chao Xie <cxie4@marvell.com>
To: Mark Brown <broonie@kernel.org>, Axel Lin <axel.lin@ingics.com>
CC: Yi Zhang <yizhang@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 30 Jun 2013 19:14:55 -0700
Subject: RE: [PATCH 1/2] regulator: 88pm800: Add missing config.of_node
 setting for regulator register
Thread-Topic: [PATCH 1/2] regulator: 88pm800: Add missing config.of_node
 setting for regulator register
Thread-Index: Ac50BnMnXiTjVJdLQiqYPs/XcIREmgB+dUlw
Message-ID: <AAD1C6EB06EE3649B35B7E026785068D2581736992@SC-VEXCH2.marvell.com>
References: <1372426354.28529.1.camel@phoenix>
 <20130628135022.GJ27646@sirena.org.uk>
In-Reply-To: <20130628135022.GJ27646@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org] 
> Sent: Friday, June 28, 2013 9:50 PM
> To: Axel Lin
> Cc: Yi Zhang; Chao Xie; Liam Girdwood; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/2] regulator: 88pm800: Add missing config.of_node setting for regulator register
> 
> On Fri, Jun 28, 2013 at 09:32:34PM +0800, Axel Lin wrote:
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>> ---
>> Hi,
>> Seems current code also needs this patch:
>> 	mfd: 88pm800: add regulator sub device [1]
>
> Oh dear.  I've just reverted the patch (my build testing hadn't caught up yet).  Chao, please resubmit for v3.12 - when you submit patches you need to either ensure it applies and builds on the relevant branch or mention the dependencies so that the build doesn't break.  In this case sending the regulator driver and matching MFD changes as a single patch series would have been the normal thing.
> 
> Please incorporate Axel's feedback into any resubmission.
It is my mistake. I should add "regulator_data" and "num_regulator" with regulator driver.
I have seen that mfd: 88pm800: add regulator sub device is already merged into Linux-next. So you mean that I need wait for 3.11 to release, then resubmit the regulator patch?
