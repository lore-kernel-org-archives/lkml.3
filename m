Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab3LTJfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:35:01 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:37623 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab3LTJb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:31:58 -0500
MIME-Version: 1.0
In-Reply-To: <20131216104222.GA19404@elgon.mountain>
References: <20131216104222.GA19404@elgon.mountain>
Date: Fri, 20 Dec 2013 10:31:57 +0100
Message-ID: <CACRpkdbXP4gsK1+c+WUYyUzjETm2kq_+CH2QDUVWLmfSAdbD=g@mail.gmail.com>
Subject: Re: [patch] pinctrl: off by one in msm_config_group_set()
From: Linus Walleij <linus.walleij@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 11:42 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:

> This should be ">= ARRAY_SIZE()" instead of "> ARRAY_SIZE()".
>
> Fixes: f365be092572 ('pinctrl: Add Qualcomm TLMM driver')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

This appears to be fixed already by one of Björn's follow-up
patches, so dropping this patch.

Yours,
Linus Walleij
