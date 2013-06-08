Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3FHPvB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 11:51:01 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:33047 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3FHPu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 11:50:59 -0400
MIME-Version: 1.0
In-Reply-To: <1370705783-2140-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1370705783-2140-1-git-send-email-Julia.Lawall@lip6.fr>
Date: Sat, 8 Jun 2013 17:50:59 +0200
Message-ID: <CACna6rwKDKriiw2Q+et02ZmhHU9U+7ni3ik=14XZDEnN54J3YQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/mtd/devices/bcm47xxsflash.c: correct argument to kfree
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: David Woodhouse <dwmw2@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/8 Julia Lawall <Julia.Lawall@lip6.fr>:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> The argument to kfree should not be the address of a structure field.
> The argument is adjusted to correspond to what is found in the subsequent
> remove function.

This was already addressed in
[PATCH RESEND 1/2] mtd: bcm47: convert kzalloc to avoid invalid access

Artem: can you pick pointed patch, please? So people don't report it
over and over ;)

-- 
Rafał
