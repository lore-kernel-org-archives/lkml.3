Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153Ab3FMSaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:30:17 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:62821 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098Ab3FMSaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:30:13 -0400
MIME-Version: 1.0
In-Reply-To: <1371128132-18266-1-git-send-email-christian.ruppert@abilis.com>
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com>
	<1371128132-18266-1-git-send-email-christian.ruppert@abilis.com>
Date: Thu, 13 Jun 2013 20:30:12 +0200
Message-ID: <CACRpkdaYFqv-soonRC37O-xOtscw6DxWmSW+8qKTiPOxwjVTcg@mail.gmail.com>
Subject: Re: [PATCH 1/2] Add pin list based GPIO ranges
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 2:55 PM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

> Traditionally, GPIO ranges are based on consecutive ranges of both GPIO
> and pin numbers. This patch allows for GPIO ranges with arbitrary lists
> of pin numbers.
>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>

I really like this patch and it seems to be useful for other purposes so I've
applied it so we get some rotation on it.

Yours,
Linus Walleij
