Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351Ab3GZXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 19:16:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34662 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760175Ab3GZXQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 19:16:23 -0400
X-Sasl-enc: 9Up7FzU1iXUK3nGd4FTfz31s1KM1Erzj/3LSEF3sc7C+ 1374880582
Date: Fri, 26 Jul 2013 16:16:21 -0700
From: GregKH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] w1: replace strict_strtol() with kstrtol()
Message-ID: <20130726231621.GB30720@kroah.com>
References: <001401ce844f$d4047db0$7c0d7910$@samsung.com>
 <1435421374523244@web23e.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1435421374523244@web23e.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 12:00:44AM +0400, Evgeniy Polyakov wrote:
> Hi everyone
> 
> 19.07.2013, 11:16, "Jingoo Han" <jg1.han@samsung.com>:
> > The usage of strict_strtol() is not preferred, because
> > strict_strtol() is obsolete. Thus, kstrtol() should be
> > used.
> 
> Looks good to me, although I do not really see the difference
> Greg, please pull into your tree or suggest appropriate.
> 
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

Can someone resend this, I don't seem to be able to find it...

thanks,

greg k-h
