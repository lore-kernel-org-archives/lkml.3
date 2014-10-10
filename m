Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaJJKZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:25:43 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34040 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751069AbaJJKZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:25:37 -0400
Message-ID: <5437B416.2080606@hurleysoftware.com>
Date: Fri, 10 Oct 2014 06:25:26 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jingchang Lu <jingchang.lu@freescale.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>, Joseph Lo <josephl@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] serial: of-serial: fix up PM ops on no_console_suspend
References: <1412845852-26157-1-git-send-email-jingchang.lu@freescale.com> <543768F3.6090703@wwwdotorg.org> <01583b7f252b4f81a5655009f6f73aba@BL2PR03MB467.namprd03.prod.outlook.com>
In-Reply-To: <01583b7f252b4f81a5655009f6f73aba@BL2PR03MB467.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 02:16 AM, Jingchang Lu wrote:
>> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
>> On 10/09/2014 02:10 AM, Jingchang Lu wrote:
>>> Mandatorily disabling the uart clock will cause register access hung
>>> on "no_console_suspend". This patch add condition check on it and only
>>> disable the clock with console_suspend_enabled true.
>>
>> It would be useful if the email/patch subject line said "V2", and there
>> was a changelog below.
> This is not a v2, patch "serial: of-serial: add PM suspend/resume support
> (commit 2dea53bf57783f243c892e99c10c6921e956aa7e)" has been merged into
> linux-next tree, this is a fixup on that PM ops.

Then please say so in the commit log. Something like,

Fix commit 2dea53bf57783f243c892e99c10c6921e956aa7e,
"serial: of-serial: add PM suspend/resume support", which
disables the uart clock on suspend, but also causes a hardware
hang on register access if no_console_suspend command line option
is used.

Regards,
Peter Hurley

