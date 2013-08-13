Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab3HMVKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:10:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:52783 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141Ab3HMVKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:10:10 -0400
Message-ID: <1376428169.4255.16.camel@pasglop>
Subject: Re: [GIT PULL] DT/core: cpu_ofnode updates for v3.12
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rob Herring <robherring2@gmail.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date: Wed, 14 Aug 2013 07:09:29 +1000
In-Reply-To: <1974929.8mIZF44QnT@vostro.rjw.lan>
References: <5208E2D3.7060005@arm.com> <520A536C.3030600@arm.com>
	 <CAL_JsqJdGXuTmb2kgBwgmRYGs9f92-dsawDXSXjmJW8cwjFVQQ@mail.gmail.com>
	 <1974929.8mIZF44QnT@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 21:45 +0200, Rafael J. Wysocki wrote:
> 
> I'd go for 1 above personally.

Yuck no. Two functions with roughly the same name and the same purpose
differing only by an underscore just because one can't take 5mn to
reconcile the new one with the old one ? No way.

Ben.


