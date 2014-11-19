Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbaKSQkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:40:52 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:55554 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbaKSQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:40:48 -0500
Date: Wed, 19 Nov 2014 16:40:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, edubezval@gmail.com,
        kernel@stlinux.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] thermal: sti: Ignore suspend/resume functions when !PM
Message-ID: <20141119164040.GG1875@x1>
References: <1416412231-2752-1-git-send-email-lee.jones@linaro.org>
 <CAOMZO5CwFSRUoVb2j=X=fzaqVN1gUyRki70ewrGrwqLWSHMoAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5CwFSRUoVb2j=X=fzaqVN1gUyRki70ewrGrwqLWSHMoAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Fabio Estevam wrote:

> On Wed, Nov 19, 2014 at 1:50 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > Prevents build warning:
> >
> > st_thermal.c:278:12:
> >     warning: ‘st_thermal_suspend’ defined but not used [-Wunused-function]
> > st_thermal.c:286:12:
> >     warning: ‘st_thermal_resume’ defined but not used [-Wunused-function]
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >
> > v1 => v2:
> >  - CONFIG_PM => CONFIG_PM_SLEEP suggested by David Paris.
> 
> You should also update the Subject to 'when !PM_SLEEP'

I guess we should, yes.

Zhang, Eduardo,

Are you happy to do that, or would you like me to re-spin again?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
