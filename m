Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab3CSPEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:04:46 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:36846 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3CSPEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:04:43 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.17.83]
In-Reply-To: <1361466940-6813-4-git-send-email-sjur.brandeland@stericsson.com>
References: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com> <1361466940-6813-4-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 19 Mar 2013 17:04:22 +0200
Message-ID: <CAK=WgbZ+7y=Z0mjJnjJWRiT_nfcE=npPxiEQHpef3D_MfFPUuQ@mail.gmail.com>
Subject: Re: [PATCHv2 03/10] remoteproc: Refactor function rproc_elf_find_rsc_table
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Cc: Ido Yariv <ido@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 7:15 PM,  <sjur.brandeland@stericsson.com> wrote:
> +static struct resource_table *
> +rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
> +                                                       int *tablesz)

Applying with a minor style change, thanks!
