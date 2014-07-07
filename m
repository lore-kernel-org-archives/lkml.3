Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaGGPyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:54:52 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:46138 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaGGPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:54:51 -0400
MIME-Version: 1.0
In-Reply-To: <1403790272-11635-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403790272-11635-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 7 Jul 2014 17:54:50 +0200
Message-ID: <CACRpkdYZgv6-bffreCvcXjBHGW09+i2dvtd7P-r77RJ8JPU9kQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-st.c: Cleaning up values that are never used
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kernel@stlinux.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 3:44 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> Remove variable that are never used
>
> This was found using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Patch applied with Patrice's ACK.

Yours,
Linus Walleij
