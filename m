Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab3CYAAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 20:00:55 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:47381 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab3CYAAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 20:00:54 -0400
Message-ID: <514F937C.9020203@gmail.com>
Date: Mon, 25 Mar 2013 03:59:56 +0400
From: Sergey Fionov <fionov@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi: be more paranoid about available space when creating
 variables
In-Reply-To: <1362271217-31747-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

My ASUS P8Z68-V PRO motherboard's UEFI cleans up EFI variables space
only if it is full when system boots.

So with this patch and 32kb of 64kb space used I can't use efibootmgr
to create new boot entries until EFI variables space become full and
then is cleaned up by UEFI.

It can be done only with 10 reboots (every boot uses 3 kilobytes of
EFI variables space) or patched efivars module.

I think it is a regression.

wbr,
Sergey.
