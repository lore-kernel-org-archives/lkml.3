Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab3CRQzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:55:55 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:10872 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751953Ab3CRQzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:55:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/hMf5UTeb1PbTa3ssjOUgx
Date: Mon, 18 Mar 2013 09:55:50 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH] pinctrl: single: correct argument for pinconf
Message-ID: <20130318165548.GA16413@atomide.com>
References: <1363161686-21616-1-git-send-email-haojian.zhuang@linaro.org>
 <CACRpkdbYKMETmtTiUZ_cqF8W2LS8gL8XX00M2j2wo49p5AcfdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbYKMETmtTiUZ_cqF8W2LS8gL8XX00M2j2wo49p5AcfdQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [130313 11:07]:
> On Wed, Mar 13, 2013 at 9:01 AM, Haojian Zhuang
> <haojian.zhuang@linaro.org> wrote:
> 
> > pcs_pinconf_set() is always using "arg << shift" to configure two
> > parameters case. But pcs_add_conf2() didn't remove shift for config
> > argument. So correct it.
> >
> > Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
> 
> Tentatively applied, unless Tony diss it...

Looks good to me:

Acked-by: Tony Lindgren <tony@atomide.com>
