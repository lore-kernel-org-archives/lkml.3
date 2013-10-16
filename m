Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695Ab3JPLZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:25:06 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38748 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760524Ab3JPLZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <1381844378-12581-1-git-send-email-christian.ruppert@abilis.com>
References: <CACRpkdZdELan7OyMjt4KOi=q-v1xkSaNZNyZ7AnOBY1R=SoW3w@mail.gmail.com>
	<1381844378-12581-1-git-send-email-christian.ruppert@abilis.com>
Date: Wed, 16 Oct 2013 13:25:01 +0200
Message-ID: <CACRpkdapAEPkvh1wbhgTggcbJ6V6un=7FWq+JjmTiTxpCvXC6A@mail.gmail.com>
Subject: Re: [PATCH V2] pinmux: Add TB10x pinmux driver
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

On Tue, Oct 15, 2013 at 3:39 PM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

> The pinmux driver of the Abilis Systems TB10x platform based on ARC700 CPUs.
> Used to control the pinmux and is a prerequisite for the GPIO driver.
>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>

Excellent work Christian, of course I cannot resist this driver now
that everything is looking good and the deps are in place, so
patch applied.

Yours,
Linus Walleij
