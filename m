Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab3LDOO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:14:59 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:49222 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab3LDOO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:14:58 -0500
Date: Wed, 4 Dec 2013 14:14:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] mfd: max14577: cleanup an error message
Message-ID: <20131204141447.GB25422@lee--X1>
References: <20131204140712.GA11681@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131204140712.GA11681@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "pdata" is a NULL not an ERR_PTR so there is no use printing it.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied with the $SUBJECT line correctly capitalised.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
