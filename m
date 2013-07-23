Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab3GWLSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:18:09 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:58078 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232Ab3GWLSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:18:05 -0400
MIME-Version: 1.0
In-Reply-To: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 23 Jul 2013 16:47:43 +0530
Message-ID: <CA+V-a8ue48_p1ysK+H3i5i_P29KTESxX2U-SU1frcyvGRLn8wQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Davinci VPBE use devres and some cleanup
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Sat, Jul 13, 2013 at 2:20 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>
> This patch series replaces existing resource handling in the
> driver with managed device resource.
>
> Lad, Prabhakar (5):
>   media: davinci: vpbe_venc: convert to devm_* api
>   media: davinci: vpbe_osd: convert to devm_* api
>   media: davinci: vpbe_display: convert to devm* api
>   media: davinci: vpss: convert to devm* api

can you pick up patches 1-4 for 3.12 ? I'll handle the 5/5 patch later.

Regards,
--Prabhakar Lad
