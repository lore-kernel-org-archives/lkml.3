Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaGGPmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:42:40 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:34388 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaGGPmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:42:37 -0400
MIME-Version: 1.0
In-Reply-To: <1403782369-10201-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403782369-10201-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 7 Jul 2014 17:42:37 +0200
Message-ID: <CACRpkdbZspN43QvMzaRSEeQzx4Z0dQSX-k-_7cbO=eGAXL8CXA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-st.c: Cleaning up if unsigned is less
 than zero
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

On Thu, Jun 26, 2014 at 1:32 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> Remove checking if a unsigned is less than zero
>
> This was found using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Patch applied with the ACKs. Thanks!

Yours,
Linus Walleij
