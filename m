Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab3KDJAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:00:41 -0500
Received: from top.free-electrons.com ([176.31.233.9]:32967 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752209Ab3KDJAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:00:41 -0500
Message-ID: <52776234.7030901@free-electrons.com>
Date: Mon, 04 Nov 2013 10:00:36 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: removed unused MACH_MXLADS Kconfig parameter
References: <1383542366-6270-1-git-send-email-michael.opdenacker@free-electrons.com> <20131104085146.GT24559@pengutronix.de>
In-Reply-To: <20131104085146.GT24559@pengutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On 11/04/2013 09:51 AM, Sascha Hauer wrote:
> On Mon, Nov 04, 2013 at 06:19:26AM +0100, Michael Opdenacker wrote:
>> This removes the MACH_MXLADS Kconfig parameter,
>> which was no longer used anywhere in the source code
>> and Makefiles.
> Hehe, this one is a bit tricky. Indeed MACH_MXLADS isn't used directly
> anywhere. Nevertheless having CONFIG_MACH_MXLADS defined makes
> machine_is_mxlads() become true when the kernel is started with a
> machine id of 1851.
Oops, that's right, got it! Thanks!
>
> machine_is_mxlads() is unused in the kernel, so this patch indeed
> doesn't hurt. Anyway, the code is correct currently, so I suggest
> keeping it until the mx[1l]ads is either removed or converted to
> devicetree.
Sounds good to me.

Thanks for your review!

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

