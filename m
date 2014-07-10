Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaGJMTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:19:00 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:40644 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbaGJMS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:18:56 -0400
Message-ID: <1404994709.16296.22.camel@iivanov-dev>
Subject: Re: [PATCH v3] pinctrl: msm: move all qualcomm drivers to subdir
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-gpio@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Date: Thu, 10 Jul 2014 15:18:29 +0300
In-Reply-To: <CAJAp7Oi-UH4SUHNw_gHtm=P8EYG3+BsA=hPAsZZWjfG5KCMJeA@mail.gmail.com>
References: <1404910216-2170-1-git-send-email-linus.walleij@linaro.org>
	 <CAJAp7Oi-UH4SUHNw_gHtm=P8EYG3+BsA=hPAsZZWjfG5KCMJeA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 15:16 -0700, Bjorn Andersson wrote:
> On Wed, Jul 9, 2014 at 5:50 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > We have four Qualcomm-related pin control drivers, and now there
> > are drivers coming in for the PMICs on these systems, so let's
> > create a qcom subdirectory to hold all the Qualcomm stuff.
> >
> > Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> > Cc: Ivan T. Ivanov <iivanov@mm-sol.com>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Nice initiative.
> 
> Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

+1 from me.

Acked-by: Ivan T. Ivanov <iivanov@mm-sol.com>


