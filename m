Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab3ILKJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:09:55 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:54935 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab3ILKJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:09:54 -0400
MIME-Version: 1.0
In-Reply-To: <1378697411-4619-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1378697411-4619-1-git-send-email-michael.opdenacker@free-electrons.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 12 Sep 2013 15:39:33 +0530
Message-ID: <CA+V-a8tOOSoJDtaDb6qcoAenJWVigwVtQ22OP7b_VrWe4bLARg@mail.gmail.com>
Subject: Re: [PATCH] [media] davinci: remove deprecated IRQF_DISABLED
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 9:00 AM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> This patch proposes to remove the IRQF_DISABLED flag from
> davinci media platform drivers.
>
> It's a NOOP since 2.6.35 and it will be removed one day.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regrads,
--Prabhakar Lad
