Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab3CUNRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:17:19 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:56009 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab3CUNRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:17:18 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.17.83]
In-Reply-To: <1361466940-6813-7-git-send-email-sjur.brandeland@stericsson.com>
References: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com> <1361466940-6813-7-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 21 Mar 2013 15:16:55 +0200
Message-ID: <CAK=WgbaXj8aVNN-9T=Ox4UrOFaJmahjt9OJUc7hVyAjWtRJGOQ@mail.gmail.com>
Subject: Re: [PATCHv2 06/10] remoteproc: Code cleanup of resource parsing
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Cc: Ido Yariv <ido@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 7:15 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Combine the almost identical functions rproc_handle_virtio_rsc
> and rproc_handle_boot_rsc.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Cool patch :)

BTW I'm almost done. Doing very small changes here and there and
briefly testing the code. Will let you test a private branch before I
push out.

Thanks,
Ohad.
