Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3C0Wez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:34:55 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:51501 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3C0Wey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:34:54 -0400
MIME-Version: 1.0
In-Reply-To: <1364422304.14860.9.camel@i7.infradead.org>
References: <1363196884-20193-1-git-send-email-jason@lakedaemon.net>
	<1363434272-23172-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<CACRpkdb-CdmzszyixBLGdZjXJXzef26u0qN9xWcrYa3JbAD3Ow@mail.gmail.com>
	<1364422304.14860.9.camel@i7.infradead.org>
Date: Wed, 27 Mar 2013 23:34:53 +0100
Message-ID: <CACRpkdZvz0f-kwS1N=wc438THUuU9_g0VFoy7OYUAiaL8hkBNw@mail.gmail.com>
Subject: Re: [PATCH v3] pinctrl: mvebu: prevent walking off the end of group array
From: Linus Walleij <linus.walleij@linaro.org>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 11:11 PM, Woodhouse, David
<david.woodhouse@intel.com> wrote:
> On Wed, 2013-03-27 at 23:06 +0100, Linus Walleij wrote:
>> Is it so critical that it needs to be tagged for stable as well
>> then tell me.
>>
>> If it's non-critical enough to live on for -next then tell me.
>
> I don't think it's critical. It'll probably never trigger in practice.

Thanks, moving it to for-next then...

Yours,
Linus Walleij
