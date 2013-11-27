Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab3K0E1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 23:27:01 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:36310 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3K0E1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 23:27:00 -0500
Date: Tue, 26 Nov 2013 20:24:41 -0800
From: Olof Johansson <olof@lixom.net>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] platform/chrome: unregister platform driver/device
 when module exit
Message-ID: <20131127042441.GA2962@quad.lixom.net>
References: <CAPgLHd8Pm5+g-m2FJ_oqQxtQ8Ewxafx=DTyd8Mm_YCgYGLqDKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd8Pm5+g-m2FJ_oqQxtQ8Ewxafx=DTyd8Mm_YCgYGLqDKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 11:34:58AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> We have registered platform driver and device when module
> init, and need unregister them when module exit.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---

Applied, thanks. I suppose it might make sense to move the i2c deregistration
to a remove function for the platform driver at some point, but this will do.


-Olof
