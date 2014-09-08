Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaIHMPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:15:35 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:59811 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbaIHMPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <53F1FBA7.8000707@neotion.com>
References: <53C7E45E.2060102@neotion.com>
	<CAPDyKFoRpQBHGGCMPvEKdeVGjTO-rnyYVostLZGCV3dudD1rmA@mail.gmail.com>
	<53EB2DC3.2080002@neotion.com>
	<CAPDyKFpjYqVUZ8GHB76gD8pOx_eMg9ecvbWrMEfbhEd5ffk7mw@mail.gmail.com>
	<53ECB95F.2030207@neotion.com>
	<CAPDyKFp2ekmucHVzMWxeKfyTmuFKTXAYwUEpL5QxvEh8AjFopg@mail.gmail.com>
	<53F1FBA7.8000707@neotion.com>
Date: Mon, 8 Sep 2014 14:15:31 +0200
Message-ID: <CAPDyKFrpj=tuZTBHC1wsOz=v-Rh6zGkWrawQzVRrwe36tEpRyg@mail.gmail.com>
Subject: Re: [PATCH v3 0002/0002] mmc: Checks EXT_CSD_PARTITION_SETTING_COMPLETED
 bit before partitions computation
From: Ulf Hansson <ulf.hansson@linaro.org>
To: =?UTF-8?B?R3LDqWdvcnkgU291dGFkw6k=?= <gsoutade@neotion.com>
Cc: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 August 2014 15:12, Grégory Soutadé <gsoutade@neotion.com> wrote:
> Checks EXT_CSD_PARTITION_SETTING_COMPLETED bit before
> computing enhanced user area offset and size, and adding
> mmc general purpose partitions.
> The two needs EXT_CSD_PARTITION_SETTING_COMPLETED bit be set
> to be valid (as described in JEDEC standard).
>
> Signed-off-by: Grégory Soutadé <gsoutade@neotion.com>
> ---
>  drivers/mmc/core/mmc.c |  167 +++++++++++++++++++++++++++---------------------
>  1 file changed, 95 insertions(+), 72 deletions(-)
>
> Changelog v2:
>         Move code for user area and general purpose partitions
>         into functions.

Overall I like the end-result of this patch.

What I don't like is that you move code and fix bugs in same patch.
Could possibly, split this up into two patches?

Kind regards
Uffe
