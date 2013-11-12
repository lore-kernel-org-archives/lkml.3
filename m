Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab3KLUic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:38:32 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:58488 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab3KLUiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:38:24 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <52828EF5.6090909@wwwdotorg.org>
References: <1383819106-1400-1-git-send-email-acourbot@nvidia.com>
	<52828EF5.6090909@wwwdotorg.org>
Date: Tue, 12 Nov 2013 12:38:23 -0800
Message-ID: <CAOesGMhatp9ZQr=eTCtQ_9a_E9LXKdTCzJd+P7Sy9Ut9wtvnsA@mail.gmail.com>
Subject: Re: [PATCH v10 0/7] ARM: support for Trusted Foundations secure monitor
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 12:26 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/07/2013 03:11 AM, Alexandre Courbot wrote:
>> Just a set of small fixes to address the concerns expressed on v9 with the
>> non-prefixed version DT properties. I hope there won't be a need for an
>> eleventh (!) version. :P
>
> BTW, this version looks fine to me. On IRC, Olof said it looked OK to
> him. I'm just waiting to hear back from Olof/Russell whether I should
> merge this through the Tegra tree, or whether the first 1-3 patches
> should go through Russell's tree.

I pinged Russell, and he brought up the fact that there were earlier
requests to move it to drivers/firmware. It would make sense to try to
get that done before merging, especially if you anticipate someone
using TF on 64-bit platforms.


-Olof
