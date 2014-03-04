Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbaCDUoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:44:22 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44228 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932782AbaCDUoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:44:16 -0500
Message-ID: <53163B1C.1020203@free-electrons.com>
Date: Tue, 04 Mar 2014 21:44:12 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [RESEND] ARM: footbridge: remove obsolete IRQF_DISABLED
References: <1386395865-11910-1-git-send-email-michael.opdenacker@free-electrons.com> <1393964413-16829-1-git-send-email-michael.opdenacker@free-electrons.com> <53163791.50202@codeaurora.org>
In-Reply-To: <53163791.50202@codeaurora.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 09:29 PM, Stephen Boyd wrote:
> On 03/04/14 12:20, Michael Opdenacker wrote:
>> This patch proposes to remove the IRQF_DISABLED flag from footbridge
>> code. It's a NOOP since 2.6.35.
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> You should send this to Russell's patch tracker[1] given that nobody has
> commented in over 6 months on two resends.
>
> [1] http://www.arm.linux.org.uk/developer/patches/info.php
>
Done, thank you for your advise!

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

