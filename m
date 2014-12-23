Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaLWRaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 12:30:20 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:46412 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaLWRaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 12:30:19 -0500
MIME-Version: 1.0
From: =?UTF-8?B?UmFmYWVsIEpvc8Op?= <rjsilvestre@gmail.com>
Date: Wed, 24 Dec 2014 01:29:58 +0800
Message-ID: <CAAuGQp=BV5n3_Cj1s-G=Xoai0Jxxf9qNfcQHk9kpmwouEE_XzQ@mail.gmail.com>
Subject: samsung-laptop module in UEFI
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I know that some time ago the UEFI installation could brick Samsung
laptops and one way to prevent this was to patch the kernel disabling
the samsung-laptop module case it detect that was running in UEFI
mode.
As far as I know Samsung already fixed the firmware and other more
permanent fixes were applied to the kernel.

For what I found from an internet search, the reason for keeping this
blacklist is because this module still can cause some issues to the
laptop.

This is a bit frustrating, as similar Samsung Settings applications
works perfectly under UEFI in Windows.

So, I would like to ask you this: since it already passed some time
from the initial issue and the kernel has some many Samsung employed
contributors is there any plans to fix this module and re-enable it in
UEFI?

Regards,
Rafael
