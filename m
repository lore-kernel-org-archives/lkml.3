Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3IEELo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:11:44 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:58886 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3IEELn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:11:43 -0400
MIME-Version: 1.0
In-Reply-To: <1378351885.16198.1.camel@phoenix>
References: <1378351885.16198.1.camel@phoenix>
Date: Thu, 5 Sep 2013 09:41:42 +0530
Message-ID: <CAK9yfHzq8FymG+_oQj22gwBEgqWQvwLsw6KTOTiZSzZ0+K7DtA@mail.gmail.com>
Subject: Re: [PATCH] regulator: palmas: Drop regulator_unregister while using devm_regulator_register
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On 5 September 2013 09:01, Axel Lin <axel.lin@ingics.com> wrote:
> Commmit af40a94aba "regulator: palmas: Use devm_regulator_register" missed
> removing a regulator_unregister() call if palmas_extreg_init falis. Fix it.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

I was about to do it. Thanks for doing :)

Acked-by: Sachin Kamat <sachin.kamat@linaro.org>

-- 
With warm regards,
Sachin
