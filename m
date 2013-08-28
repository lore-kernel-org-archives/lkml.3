Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3H1Mc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:32:56 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:44570 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3H1Mcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:32:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130826160350.GE12428@elgon.mountain>
References: <20130826160350.GE12428@elgon.mountain>
Date: Wed, 28 Aug 2013 14:32:54 +0200
Message-ID: <CACRpkdZtBjM8rnubhvCyyB7ZNdcsY+LD+xqsmXZMP2qZobz2_Q@mail.gmail.com>
Subject: Re: [patch] pinctrl: abx500: fix bitwise AND test
From: Linus Walleij <linus.walleij@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Patrice CHOTARD <patrice.chotard@st.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 6:03 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The intent here was to test if the bit was set or not but there is a
> logical vs bitwise AND typo so it is true if any bits are set.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I can't compile this.

Works for me so patch applied.

Patrice: looks all right?

Yours,
Linus Walleij
