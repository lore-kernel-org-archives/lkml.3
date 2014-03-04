Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbaCDKc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:32:58 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:56022 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651AbaCDKc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:32:57 -0500
Message-ID: <5315ABD2.9030809@gmail.com>
Date: Tue, 04 Mar 2014 11:32:50 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] ASoC: kirkwood: prepare new Dove DT Kconfig variable
References: <1393536486-3827-3-git-send-email-sebastian.hesselbarth@gmail.com> <1393662801-17950-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140304040314.GC2411@sirena.org.uk>
In-Reply-To: <20140304040314.GC2411@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 05:03 AM, Mark Brown wrote:
> On Sat, Mar 01, 2014 at 09:33:17AM +0100, Sebastian Hesselbarth wrote:
>> DT-enabled Dove will move over from ARCH_DOVE in mach-dove to MACH_DOVE in
>> mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
>> DT-only MACH_DOVE Kconfig.
>
> This doesn't apply against current ASoC, please check and resend.

Mark,

actually looking at what that specific Kconfig will look like in
asoc/for-next, I guess the current version is sufficient already.

It already says:

depends on ARCH_KIRKWOOD || ARCH_DOVE || ARCH_MVEBU || COMPILE_TEST

and MACH_DOVE will be part of ARCH_MVEBU.

Thanks for pointing this out, please ignore this patch.

Sebastian
