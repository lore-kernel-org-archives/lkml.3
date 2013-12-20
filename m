Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422700Ab3LTMra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:47:30 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:63294 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422643Ab3LTMrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:47:23 -0500
MIME-Version: 1.0
In-Reply-To: <1387293923-27236-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1387293923-27236-1-git-send-email-prabhakar.csengg@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 20 Dec 2013 18:17:01 +0530
Message-ID: <CA+V-a8sdCuO1U3Egn62g_QivmVUEXzF4RgKbi-Ksm7JZEY-KKA@mail.gmail.com>
Subject: Re: [PATCH] media: davinci_vpfe: fix build error
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: devel@driverdev.osuosl.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Tue, Dec 17, 2013 at 8:55 PM, Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>
> This patch includes linux/delay.h required for msleep,
> which fixes following build error.
>
> dm365_isif.c: In function ‘isif_enable’:
> dm365_isif.c:129:2: error: implicit declaration of function ‘msleep’
>
Will you pick this patch or shall I go ahead and  issue a pull to Mauro ?

Regards,
--Prabhakar Lad
