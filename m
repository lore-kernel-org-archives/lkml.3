Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab3F0ISl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:18:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:28877 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab3F0ISh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:18:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="356517004"
Message-ID: <1372321107.24799.75.camel@smile>
Subject: Re: [PATCH 5/8] minnowboard-gpio: Export MinnowBoard expansion GPIO
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        danders@circuitco.com, vishal.l.verma@intel.com,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        platform-driver-x86@vger.kernel.org
Date: Thu, 27 Jun 2013 11:18:27 +0300
In-Reply-To: <1372263718.8177.74.camel@envy.home>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <c7bed09378e5edf88872e277b238ecc3f52634aa.1372211451.git.dvhart@linux.intel.com>
	 <1372233328.24799.48.camel@smile> <1372263718.8177.74.camel@envy.home>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 09:21 -0700, Darren Hart wrote: 
> On Wed, 2013-06-26 at 10:55 +0300, Andy Shevchenko wrote:

> > > + out:
> > > +	return err;
> > 
> > Are you planning to add something else to 'out' path?
> > Otherwise I think it will look better if you do return instead of
> > [useless] gotos.
> 
> I suppose this is a matter of preference. I am allergic to multiple
> return points. However, your argument is consistent with CodingStyle
> Chapter 7 in that it states "and some common work such as cleanup has to
> be done." If that "and" is a required sort of &&, then I should change
> it. Do others have a strong opinion here?

There was recently similar discussion. Author finally agreed to change:
http://www.spinics.net/lists/arm-kernel/msg252108.html

"I did say in the changelog I opted for goto over return. But since
everybody keeps preferring returns..."

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
