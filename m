Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3ETLTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:19:46 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:58994 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab3ETLTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 07:19:44 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC PATCHv3 3/6] clk: Add TI-Nspire clock drivers
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <201305192148.46398.arnd@arndb.de>
Date: Mon, 20 May 2013 21:19:33 +1000
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Content-Transfer-Encoding: 7bit
Message-Id: <C574C0B3-194E-451A-8584-A351D85C5792@gmail.com>
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com> <201305161417.28133.arnd@arndb.de> <F8915E01-0FCA-4C9F-8440-63B5A73B349B@gmail.com> <201305192148.46398.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 20/05/2013, at 5:48 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> On Sunday 19 May 2013, Daniel Tang wrote:
>> If the vendors for the on-SOC components are unknown, should we just
>> leave the compatible strings as is (i.e. "nspire-XXX")?
> 
> In that case, I would use the name of the company that made the SoC.
> I believe someone mentioned it was made by LSI logic.

Yep, that's right. So "lsi,nspire-XXX" should be fine?

> 
> 	Arnd

