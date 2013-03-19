Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3CSNbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:31:24 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:51895 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab3CSNbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:31:23 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.17.83]
In-Reply-To: <1361466940-6813-3-git-send-email-sjur.brandeland@stericsson.com>
References: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com> <1361466940-6813-3-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 19 Mar 2013 15:31:01 +0200
Message-ID: <CAK=WgbYjMu7ifO7ppc51T+06LR92XNF3WTdRHJFN968vL+ddgQ@mail.gmail.com>
Subject: Re: [PATCHv2 02/10] remoteproc: Bugfix remove entry from list before
 freeing it
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
> Remove the vdev entry from the list before freeing it,
> otherwise the rproc->vdevs list get corrupted.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Cc'ing stable here too and slightly modifying subject+commit log.

Thanks!
