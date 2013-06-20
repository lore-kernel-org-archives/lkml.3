Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab3FTIPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:15:15 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43163 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab3FTIPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:15:12 -0400
Message-ID: <1371716106.3231.0.camel@hornet>
Subject: Re: [PATCH] power/reset: Make the vexpress driver optional on arm
 and arm64
From: Pawel Moll <pawel.moll@arm.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        l@vger.kernel.org
Cc: "inux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Date: Thu, 20 Jun 2013 09:15:06 +0100
In-Reply-To: <1370877121-26211-1-git-send-email-pawel.moll@arm.com>
References: <1370877121-26211-1-git-send-email-pawel.moll@arm.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 20 Jun 2013 08:15:08.0038 (UTC) FILETIME=[46C45A60:01CE6D8E]
X-MC-Unique: 113062009151000201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-10 at 16:12 +0100, Pawel Moll wrote:
> The driver can be used on either arm or arm64 platforms, but
> the latter doesn't have any platform-specific configuration
> options, so it must be possible to manually enable the driver.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  drivers/power/reset/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Hello Anton, David,
> 
> Would you be so kind to queue this small change for 3.11?
> 
> Thanks!
> 
> Pawel

This is just a friendly and polite reminder...

Paweł


