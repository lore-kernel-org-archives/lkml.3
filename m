Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163106Ab3DFA01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 20:26:27 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51631 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163079Ab3DFA00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 20:26:26 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <201304041112.25780.arnd@arndb.de>
Date: Sat, 6 Apr 2013 11:26:19 +1100
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        fabian@ritter-vogt.de, Lionel Debroux <lionel_debroux@yahoo.fr>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <8FB21B56-58BC-4530-8C7A-71A32856210D@gmail.com>
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com> <201304041112.25780.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

First of all, thank you for your comments!

On 04/04/2013, at 10:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> For new platforms, we want to have only the absolute minimum amount of
> code in arch/arm and move everything else into drivers. However, that
> is only possible using device tree. It should not add any significant
> complexity to your code, and you can easily bundle the device tree blob
> with the kernel.

Given that most of your comments described some very fundamental changes (esp switching to DTB) to the structure of our port, we've decided we'll probably start from scratch and fix the issues you outlined as we reimplement our platform.

At the moment, we're working on getting a basic DTB-booting kernel working so our next patch will be starting from basics.

Cheers,
tangrs