Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3BAJ5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:57:47 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:40629 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab3BAJ5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:57:44 -0500
MIME-Version: 1.0
In-Reply-To: <1359545229-14620-1-git-send-email-thierry.reding@avionic-design.de>
References: <1359545229-14620-1-git-send-email-thierry.reding@avionic-design.de>
Date: Fri, 1 Feb 2013 10:57:43 +0100
Message-ID: <CACRpkdaKYUjPo4mCv6ZVszy9NuPLsPs7BQAXS--MnO-y-V9FMA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Remove newly introduced __dev* annotations
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Patrice Chotard <patrice.chotard@st.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 12:27 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:

> __devinit, __devexit and __devexit_p have been removed and should no
> longer be used.
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Hm I think I removed these just the other day ... may have been
around the time you sent this patch. Anyway, they're not there
anymore.

Thanks,
Linus Walleij
