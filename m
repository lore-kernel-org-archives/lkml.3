Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3IWIr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:47:56 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51059 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab3IWIry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:47:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130917104754.GA29918@elgon.mountain>
References: <20130917104754.GA29918@elgon.mountain>
Date: Mon, 23 Sep 2013 10:47:53 +0200
Message-ID: <CACRpkdb+cRbq8B09O+CtiFVHEcvRq4K4JZ1CFNx+h4n3tPvfBA@mail.gmail.com>
Subject: Re: [patch] pinctrl: remove an unnecessary cast
From: Linus Walleij <linus.walleij@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 12:47 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:

> sizeof() is already size_t so there is no need to cast here.  Generally,
> casting inside the min() macro instead of using min_t() is considered
> bad style.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied!

Thanks,
Linus Walleij
