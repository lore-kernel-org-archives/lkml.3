Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3A1Dmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:42:46 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:45694 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3A1Dmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:42:43 -0500
MIME-Version: 1.0
In-Reply-To: <20130127002251.GE1174@sortiz-mobl>
References: <1357633882-5191-1-git-send-email-sachin.kamat@linaro.org>
	<20130108103653.GH4544@opensource.wolfsonmicro.com>
	<CAK9yfHzgnH3z57=yjHPeURP7=SU5oYPoyM3meeV=h295T+ZW3Q@mail.gmail.com>
	<20130127002251.GE1174@sortiz-mobl>
Date: Mon, 28 Jan 2013 09:12:43 +0530
Message-ID: <CAK9yfHyfKrPMgwPavQmObApS6T-BCxnFNTvVBjrH9dOgqjHe6Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] mfd: wm8994: Use devm_regulator_bulk_get API
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 January 2013 05:52, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Sachin,
>
> On Thu, Jan 24, 2013 at 09:13:20AM +0530, Sachin Kamat wrote:
>> Hi Samuel,
>>
>> On 8 January 2013 16:06, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
>> > On Tue, Jan 08, 2013 at 02:01:22PM +0530, Sachin Kamat wrote:
>> >> devm_regulator_bulk_get is device managed and saves some cleanup
>> >> and exit code.
>> >
>> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>>
>> Would you be picking this patch up?
> I will, yes.

Thanks Samuel.

There is also another patch that needs your attention (pending for a while).
https://lkml.org/lkml/2012/12/7/65

-- 
With warm regards,
Sachin
