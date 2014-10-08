Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaJHSLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:11:09 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:23451 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751919AbaJHSLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:11:07 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 162.217.72.246
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/G2OJuORqz0b5r02HQU0/Y
Date: Wed, 8 Oct 2014 11:10:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: He YunLei <heyunlei@huawei.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, robh+dt@kernel.org,
        wangbintian@huawei.com, liguozhu@hisilicon.com,
        kong.kongxinwei@hisilicon.com
Subject: Re: [RFC PATCH] pinctrl: pinctrl-single.c:  init pinctrl single at
 arch_initcall time
Message-ID: <20141008181027.GE10014@atomide.com>
References: <542934F4.10303@huawei.com>
 <20140929175427.GE3122@atomide.com>
 <54349671.6090008@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54349671.6090008@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* He YunLei <heyunlei@huawei.com> [141007 18:43]:
> 
> Thanks for your review and I am really appreciated it, but in our arm
> platform, we haven't custom initcall levels for other drivers. Although
> deferred probe helps other drivers to register well, we are also confused
> for the issues of lots of pin request errors debug output while booting the
> kernel. Besides, if the number is bigger than the limited number, whether
> deferred probe can solve this problem.

OK. Care to provide some examples where this happens on your
platform?

Note that we already have pinctrl very early in drivers/Makefile.
What are the early users for pinctrl-single in your setup?

Regards,

Tony
