Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab3EGMaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:30:16 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44258 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559Ab3EGMaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:30:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_nr=X9JsE3w7BYg3GtbCFzMuvgoNAQPAGgM2h0g0injg@mail.gmail.com>
References: <CAPgLHd_nr=X9JsE3w7BYg3GtbCFzMuvgoNAQPAGgM2h0g0injg@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 7 May 2013 17:59:52 +0530
Message-ID: <CA+V-a8tW22dfpFzKs2K92mgoJUWVsy7V9P1nYsidmLC7xbGEOg@mail.gmail.com>
Subject: Re: [PATCH] [media] davinci: vpfe: fix error return code in vpfe_probe()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sakari Ailus <sakari.ailus@iki.fi>, yongjun_wei@trendmicro.com.cn,
        linux-media <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

Thanks for the patch.

On Tue, May 7, 2013 at 5:21 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
