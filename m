Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630Ab3JPLTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:19:38 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:55817 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760549Ab3JPLTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:19:35 -0400
MIME-Version: 1.0
In-Reply-To: <1381844274-12486-1-git-send-email-christian.ruppert@abilis.com>
References: <20131015133621.GA7461@ab42.lan>
	<1381844274-12486-1-git-send-email-christian.ruppert@abilis.com>
Date: Wed, 16 Oct 2013 13:19:35 +0200
Message-ID: <CACRpkdbD9gJnF4C4ZeO2o0Q2RcL3w8=Hnu93EWJHyxUPwn29og@mail.gmail.com>
Subject: Re: [PATCH V2] Make non-linear GPIO ranges accesible from gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 3:37 PM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

> This patch adds the infrastructure required to register non-linear gpio
> ranges through gpiolib and the standard GPIO device tree bindings.
>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>

OK this is looking fully acceptable, so applied it.

(If some DT reviewer dislikes it, this is a good time to protest.)

Christain, can you check if Documentation/pinctrl.txt needs to
be updated for this?

Yours,
Linus Walleij
