Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaHFLVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 07:21:20 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:40274 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbaHFLVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:21:19 -0400
Message-ID: <1407324061.2475.79.camel@iivanov-dev>
Subject: Re: [PATCH] i2c: qup: disable clks and return instead of just
 returning error
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>
Date: Wed, 06 Aug 2014 14:21:01 +0300
In-Reply-To: <1407311602-15751-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1407311602-15751-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-06 at 13:23 +0530, Pramod Gurav wrote:
> This fixes a error handling scenario where clocks were not being disabled
> when QUP_OUTPUT_BLOCK_SIZE returns a size greater thanat size of blk_sizes
> array. So this patch adds a statement to jump to err lable to release the
> clocks.
> 
> CC: Wolfram Sang <wsa@the-dreams.de>
> CC: Grant Likely <grant.likely@linaro.org>
> CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> CC: Andy Gross <agross@codeaurora.org>
> CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Acked-by: Ivan T. Ivanov <iivanov@mm-sol.com>

Thanks.

