Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab3HQWWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 18:22:51 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:38240 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab3HQWWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 18:22:49 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        Rob Herring <rob.herring@calxeda.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [RFC PATCH v2 3/4] powerpc: refactor of_get_cpu_node to support other architectures
Date: Sun, 18 Aug 2013 00:22:43 +0200
Message-ID: <6043373.ZgY5Yo1tNM@flatron>
User-Agent: KMail/4.11 (Linux/3.10.6-gentoo; KDE/4.11.0; x86_64; ; )
In-Reply-To: <1376777376.25016.11.camel@pasglop>
References: <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <2032060.4bgTKOdEX2@flatron> <1376777376.25016.11.camel@pasglop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 of August 2013 08:09:36 Benjamin Herrenschmidt wrote:
> On Sat, 2013-08-17 at 12:50 +0200, Tomasz Figa wrote:
> > I wonder how would this handle uniprocessor ARM (pre-v7) cores, for
> > which
> > the updated bindings[1] define #address-cells = <0> and so no reg
> > property.
> > 
> > [1] - http://thread.gmane.org/gmane.linux.ports.arm.kernel/260795
> 
> Why did you do that in the binding ? That sounds like looking to create
> problems ...

[Copying Lorenzo...]

I'm not the author of the change. I was just passing by, while the 
question showed up in my mind. ;)

> Traditionally, UP setups just used "0" as the "reg" property on other
> architectures, why do differently ?

Right, especially since the ARM DT topology parsing code still considers a 
device tree without reg property in cpu node invalid.

Best regards,
Tomasz

