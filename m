Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3GHNlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:41:04 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37021 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3GHNlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:41:02 -0400
MIME-Version: 1.0
In-Reply-To: <20130708132833.GD27646@sirena.org.uk>
References: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
	<1372510280-31931-7-git-send-email-yadi.brar@samsung.com>
	<20130708132833.GD27646@sirena.org.uk>
Date: Mon, 8 Jul 2013 19:11:01 +0530
Message-ID: <CAKew6eXHVsJCZ5wpvinhfdogDZG5rW+Z8xfTWCi-izB7=MiArg@mail.gmail.com>
Subject: Re: [v2 PATCH 6/6] mfd: s2mps11: Add device tree support
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>, linux-kernel@vger.kernel.org,
        sbkim73@samsung.com, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 8, 2013 at 6:58 PM, Mark Brown <broonie@kernel.org> wrote:
> On Sat, Jun 29, 2013 at 06:21:20PM +0530, Yadwinder Singh Brar wrote:
>> This patch adds DT compatible string for s2mps11 and binding documentation.
>>
>> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
>
> Reviewed-by: Mark Brown <broonie@linaro.org>
>
> It looks like this should be OK to merge via the MFD tree separately to
> the regulator changes, or I can apply it to the regualtor tree if that's
> easier for people.

Yes, it can be merged via MFD, thats why I put it at last.
Either way it will fine.

Thanks,
Yadwinder
