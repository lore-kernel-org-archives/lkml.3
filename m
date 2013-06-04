Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3FDJAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:00:17 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:42862 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3FDJAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:00:13 -0400
MIME-Version: 1.0
In-Reply-To: <1369920465-13905-3-git-send-email-fabio.baltieri@linaro.org>
References: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
	<1369920465-13905-3-git-send-email-fabio.baltieri@linaro.org>
Date: Tue, 4 Jun 2013 11:00:13 +0200
Message-ID: <CACRpkdbB-=u-1v=1NBNn10HJa3eKXMpu=z6OcpDk=+NBKZmhHA@mail.gmail.com>
Subject: Re: [PATCH 2/5] ARM: ux500: Correct anamic2 typo in DT files
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 3:27 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Fix typo of VAMIC2 LDO regulator name in some DT-related files.  This
> patch replaces all occurrences with the right name.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Patch applied to my ux500-devicetree branch.

Yours,
Linus Walleij
