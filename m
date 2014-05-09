Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbaEIPrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:47:51 -0400
Received: from static.88-198-71-155.clients.your-server.de ([88.198.71.155]:58949
	"EHLO socrates.bennee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaEIPrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:47:47 -0400
X-Greylist: delayed 1104 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 May 2014 11:47:46 EDT
References: <1387597376-29303-1-git-send-email-isubramanian@apm.com> <1387597376-29303-3-git-send-email-isubramanian@apm.com> <1390582906.12454.26.camel@deneb.redhat.com> <CAKh23FmGYGkCbeh4DbL4_NO6ypkw4F70J0X__KxFyHTo-=WtKg@mail.gmail.com>
User-agent: mu4e 0.9.9.6pre3; emacs 24.3.90.9
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Iyappan Subramanian <isubramanian@apm.com>
Cc: Mark Salter <msalter@redhat.com>, davem@davemloft.net,
        Greg KH <gregkh@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "jcm\@redhat.com" <jcm@redhat.com>, patches <patches@apm.com>,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Subject: Re: [PATCH 2/5] arm64: dts: APM X-Gene SoC Ethernet device tree nodes
In-reply-to: <CAKh23FmGYGkCbeh4DbL4_NO6ypkw4F70J0X__KxFyHTo-=WtKg@mail.gmail.com>
Date: Fri, 09 May 2014 16:29:22 +0100
Message-ID: <87ppjnc6nh.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: alex.bennee@linaro.org
X-SA-Exim-Scanned: No (on socrates.bennee.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Iyappan Subramanian <isubramanian@apm.com> writes:

> Hi Mark,
>
> Thanks for the review comment and I apologize for not replying sooner.
>
> We are completely redesigning the ethernet driver to make it simple
> and cleaner and will be posted shortly.

Hi Iyappan,

Did this ever get posted? I'm trying to get a close-to-HEAD kernel up
and running on our APM hardware but have run afoul of the differences
between the latest XGENE_MBOX patch set and the older NET_XGENE patch
set.

If it's not long away then I shall wait a bit otherwise I'll see if the
missing bits can be forward ported from our working
3.8.0-mustang_sw_1.08.12-beta_rc.jcm15 kernel (purely for testing
purposes).

Do you have a public tree where your latest kernels are visible?

Cheers,

--
Alex Bennée
QEMU/KVM Hacker for Linaro

