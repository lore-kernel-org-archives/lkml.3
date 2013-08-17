Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab3HQWPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 18:15:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:44391 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab3HQWPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 18:15:52 -0400
Message-ID: <1376777376.25016.11.camel@pasglop>
Subject: Re: [RFC PATCH v2 3/4] powerpc: refactor of_get_cpu_node to support
 other architectures
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        Rob Herring <rob.herring@calxeda.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>
Date: Sun, 18 Aug 2013 08:09:36 +1000
In-Reply-To: <2032060.4bgTKOdEX2@flatron>
References: <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376674791-28244-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376674791-28244-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <2032060.4bgTKOdEX2@flatron>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-17 at 12:50 +0200, Tomasz Figa wrote:
> I wonder how would this handle uniprocessor ARM (pre-v7) cores, for
> which 
> the updated bindings[1] define #address-cells = <0> and so no reg 
> property.
> 
> [1] - http://thread.gmane.org/gmane.linux.ports.arm.kernel/260795

Why did you do that in the binding ? That sounds like looking to create
problems ... 

Traditionally, UP setups just used "0" as the "reg" property on other
architectures, why do differently ?

Ben.




