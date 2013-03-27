Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3C0WHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:07:01 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:39980 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3C0WG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:06:59 -0400
MIME-Version: 1.0
In-Reply-To: <1363434272-23172-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1363196884-20193-1-git-send-email-jason@lakedaemon.net>
	<1363434272-23172-1-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Wed, 27 Mar 2013 23:06:59 +0100
Message-ID: <CACRpkdb-CdmzszyixBLGdZjXJXzef26u0qN9xWcrYa3JbAD3Ow@mail.gmail.com>
Subject: Re: [PATCH v3] pinctrl: mvebu: prevent walking off the end of group array
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 12:44 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> From: David Woodhouse <dwmw2@infradead.org>
>
> While investigating (ab)use of krealloc, David found this bug.  It's
> unlikely to occur, but now we detect the condition and error out
> appropriately.
>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

OK this v2 version applied for fixes...

Is it so critical that it needs to be tagged for stable as well
then tell me.

If it's non-critical enough to live on for -next then tell me.

Yours,
Linus Walleij
