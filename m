Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab3IJLI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:08:27 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:53892 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3IJLI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:08:26 -0400
Date: Tue, 10 Sep 2013 12:08:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: wwang <wei_wang@realsil.com.cn>
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, micky_ching@realsil.com.cn
Subject: Re: [PATCH v3] mfd: rtsx: Modify rts5249_optimize_phy
Message-ID: <20130910110821.GD1456@lee--X1>
References: <1378804397-28640-1-git-send-email-wei_wang@realsil.com.cn>
 <20130910092857.GB1456@lee--X1>
 <522EED3A.9080806@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <522EED3A.9080806@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, wwang wrote:

> 于 2013年09月10日 17:28, Lee Jones 写道:
> >I would like some more information in the commit log though. You're
> >making a lot of configuration changes here and due to the
> >incomprehensible 'magic numbers' used previously, it's impossible to
> >know what you're changing by just reading the code.
> >
> >Why won't the rts**** be initialise properly and what exactly are you
> >changing to rectify the situation?
> 
> Hi Lee:
> 
> It's a little difficult to describe it very clearly. To put it
> simply, the default setting of rts5249 is not good, and it will
> cause the signal quality very bad. So we have to change those values
> to achieve a better signal quality.
> 
> Do I need amend the commit and add the above description and resend it ?

I'm not asking for in-depth analysis, just an overview.

What's wrong with the default config?
Why is the signal quality bad and what makes it bad?
What did the old magic numbers do?
How will the configuration differ if I applied your patch?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
