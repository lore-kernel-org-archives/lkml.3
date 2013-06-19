Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab3FSNo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:44:27 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63056 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab3FSNoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:44:24 -0400
MIME-Version: 1.0
In-Reply-To: <1369914361-4237-1-git-send-email-ratbert.chuang@gmail.com>
References: <CANutaR_ZHWdXQrZNBN91K==n3taMKBptmyU0+8DT1RzBStNCyA@mail.gmail.com>
	<1369914361-4237-1-git-send-email-ratbert.chuang@gmail.com>
Date: Wed, 19 Jun 2013 15:44:23 +0200
Message-ID: <CACmBeS3jtkdaREQ7hc2KHzsuR5OULXRMvMiO_fz0ggnYTHJvQA@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: map_init_section flushes incorrect pmd
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, will.deacon@arm.com,
        rob.herring@calxeda.com, catalin.marinas@arm.com, nico@linaro.org,
        r.sricharan@ti.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 May 2013 13:46, Po-Yu Chuang <ratbert.chuang@gmail.com> wrote:
> This bug was introduced in commit e651eab0.
> Some v4/v5 platforms failed to boot due to this.

Thanks!

Confirming that this fixes boot on MOXA ART (FA526).

Best regards,
Jonas
