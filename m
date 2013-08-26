Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab3HZNzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:55:11 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:40086 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3HZNzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:55:09 -0400
MIME-Version: 1.0
In-Reply-To: <1377519801.80692.YahooMailNeo@web163906.mail.gq1.yahoo.com>
References: <1377519801.80692.YahooMailNeo@web163906.mail.gq1.yahoo.com>
Date: Mon, 26 Aug 2013 15:55:08 +0200
Message-ID: <CA+xJJ18+z1hiNByNQPZ8Xm+wcSLrnnYn4x4OFu+_NkSKq7oR5Q@mail.gmail.com>
Subject: Re: how to make a option in menuconfig as new feature
From: Mats Liljegren <liljegren.mats2@gmail.com>
To: Suki Buryani <sukiburyani@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 2:23 PM, Suki Buryani <sukiburyani@yahoo.com> wrote:
> Hi,
>
> I want to add up a kernel module to my linux
> kernel,currently i am mannuly changing .config file to include my new
> module but i want to add it as option in menuconfig from where i choose
> it where it should be included or not...

I think the answer to your question lies in those Kconfig files. Find
a name of some simple driver and check how that driver is defined in
Kconfig. Check Documentation/kbuild/kconfig-language.txt for more
information about these Kconfig files.

Regards
Mats Liljegren
