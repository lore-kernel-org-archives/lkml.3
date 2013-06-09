Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3FIQJC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 12:09:02 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:64617 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab3FIQJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 12:09:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-1y9xLM_0roXvO0ASOWSOWZHWB+MUTfHL2s3m-RO9T1g@mail.gmail.com>
References: <CAPgLHd-1y9xLM_0roXvO0ASOWSOWZHWB+MUTfHL2s3m-RO9T1g@mail.gmail.com>
Date: Sun, 9 Jun 2013 19:09:00 +0300
Message-ID: <CAHp75VfOzDEfcDXSLYFQO0k3_v9ghw6oXrWeSxfB5T5ph6mg0Q@mail.gmail.com>
Subject: Re: [PATCH] pcmcia: pd6729: fix error return code in pd6729_pci_probe()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Miao <eric.y.miao@gmail.com>, yongjun_wei@trendmicro.com.cn,
        linux-pcmcia@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 5:16 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.

What about to move the driver to pcim_*/devm_* functions?

--
With Best Regards,
Andy Shevchenko
