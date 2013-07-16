Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352Ab3GPQ6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:58:49 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933275Ab3GPQ6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:58:46 -0400
Message-ID: <51E57BC1.4090904@nod.at>
Date: Tue, 16 Jul 2013 18:58:41 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] um/configs: don't use devtmpfs in defconfig
References: <1373993525-25629-1-git-send-email-artagnon@gmail.com>
In-Reply-To: <1373993525-25629-1-git-send-email-artagnon@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.07.2013 18:52, schrieb Ramkumar Ramachandra:
> Avoid creating lots of bogus devices nodes like /dev/tty* (since
> User-Mode Linux does not have virtual consoles.
> 
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Jeff Dike <jdike@addtoit.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---

NAK.

If you don't want devtmpfs, just disable it in your config.

Thanks,
//richard
