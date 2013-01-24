Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3AXDna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:43:30 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:38382 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3AXDnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:43:21 -0500
MIME-Version: 1.0
In-Reply-To: <20130108103653.GH4544@opensource.wolfsonmicro.com>
References: <1357633882-5191-1-git-send-email-sachin.kamat@linaro.org>
	<20130108103653.GH4544@opensource.wolfsonmicro.com>
Date: Thu, 24 Jan 2013 09:13:20 +0530
Message-ID: <CAK9yfHzgnH3z57=yjHPeURP7=SU5oYPoyM3meeV=h295T+ZW3Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] mfd: wm8994: Use devm_regulator_bulk_get API
From: Sachin Kamat <sachin.kamat@linaro.org>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On 8 January 2013 16:06, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Jan 08, 2013 at 02:01:22PM +0530, Sachin Kamat wrote:
>> devm_regulator_bulk_get is device managed and saves some cleanup
>> and exit code.
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Would you be picking this patch up?


-- 
With warm regards,
Sachin
