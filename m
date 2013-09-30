Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab3I3LwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:52:21 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:54954 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3I3LwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:52:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130930110125.GY19304@sirena.org.uk>
References: <1380531434-15875-1-git-send-email-sachin.kamat@linaro.org>
	<20130930110125.GY19304@sirena.org.uk>
Date: Mon, 30 Sep 2013 17:22:19 +0530
Message-ID: <CAK9yfHzxDTp=_upSN0b+c-HtAPgVSOR9GODadJZTnKiMGXczow@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: ti-abb: Remove redundant of_match_ptr
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 September 2013 16:31, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Sep 30, 2013 at 02:27:13PM +0530, Sachin Kamat wrote:
>
> Note that one of the things these macros are supposed to do (but don't
> yet IIRC) is allow for dead code elimination to discard references to
> things automatically even without the being ifdefed out.

Yes that is correct. However, in this particular case all that
of_match_ptr() does
is make the pointer NULL if CONFIG_OF is disabled else assign it as
is. Since CONFIG_OF
is not used in these files, I thought it would be an appropriate cleanup.

-- 
With warm regards,
Sachin
