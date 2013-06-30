Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab3F3FBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 01:01:37 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:63656 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3F3FBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 01:01:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130628113505.GG27646@sirena.org.uk>
References: <1372066617-23518-1-git-send-email-sachin.kamat@linaro.org>
	<20130624152553.GT27646@sirena.org.uk>
	<CAK9yfHzBPO1Yr7_qLtw3oZKVVtqDBK_Yj7_r=HrU+94pod+XVA@mail.gmail.com>
	<20130628113505.GG27646@sirena.org.uk>
Date: Sun, 30 Jun 2013 10:31:33 +0530
Message-ID: <CAK9yfHyiJA0OXuEJyT26tRz9112T-0x4dKUFJ1DKjGYR_By_Cw@mail.gmail.com>
Subject: Re: [PATCH 1/1] of/documentation: Update s5m8767-regulator bindings document
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org, rob@landley.net,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 June 2013 17:05, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Jun 25, 2013 at 11:56:12AM +0530, Sachin Kamat wrote:
>
>> There is no change in the bindings, but just a correction in the
>> documentation to reflect the
>> implementation. Earlier when Samsung platforms did not have pinctrl
>> driver, legacy GPIO driver
>> was used which took those 5 parameters. Now since we are using
>> pinctrl, we need only 3 parameters.
>> The document was somehow not updated to reflect this change.
>
> So there was a previous change to the code that mistakenly didn't update
> the binding document?

Yes, that is correct. In fact the changes happened during the review
process itself. Hence there is no commit history of this change.
However the binding document was not updated during the review phase
and the first version itself got committed as it is.

-- 
With warm regards,
Sachin
