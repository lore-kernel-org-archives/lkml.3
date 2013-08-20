Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3HTVte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:49:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:36934 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab3HTVtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:49:32 -0400
Message-ID: <1377035309.25016.167.camel@pasglop>
Subject: Re: [PATCH v4 03/19] powerpc: refactor of_get_cpu_node to support
 other architectures
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Date: Wed, 21 Aug 2013 07:48:29 +1000
In-Reply-To: <52135F86.9020401@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376991021-12160-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <3703987.W8AZjrDbn0@vostro.rjw.lan> <52135F86.9020401@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 13:22 +0100, Sudeep KarkadaNagesha wrote:
> Correct, he has reviewed but I am waiting for his ACK before I could
> sent you pull request. Hopefully I should be able to send pull request
> tomorrow with his ACK.
> 
> Hi Ben,
> 
> If this is patch is fine, can I have your ACK ?

I just want to test it (just in case...), will give an Ack then.

Cheers,
Ben.


