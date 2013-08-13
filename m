Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3HMVJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:09:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:52761 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758936Ab3HMVJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:09:01 -0400
Message-ID: <1376428103.4255.15.camel@pasglop>
Subject: Re: [GIT PULL] DT/core: cpu_ofnode updates for v3.12
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date: Wed, 14 Aug 2013 07:08:23 +1000
In-Reply-To: <CAL_JsqJdGXuTmb2kgBwgmRYGs9f92-dsawDXSXjmJW8cwjFVQQ@mail.gmail.com>
References: <5208E2D3.7060005@arm.com> <3356439.a21MloFP7n@vostro.rjw.lan>
	 <520A536C.3030600@arm.com>
	 <CAL_JsqJdGXuTmb2kgBwgmRYGs9f92-dsawDXSXjmJW8cwjFVQQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 13:44 -0500, Rob Herring wrote:
> It is up to Rafael if he is willing/able to rebase his tree, but I
> would drop this series until this is sorted out. I think the new
> common function should be and can be generalized to work for powerpc.
> It would need to make reg property optional and pass in the device
> node to the arch specific function.
> 
> A short term solution would be just to make the function "#ifndef
> CONFIG_PPC".

Please, no ifdef's with different signatures. Let's agree on the
prototype first (ie, thread output argument) and make the generic
one weak.

Cheers,
Ben.


