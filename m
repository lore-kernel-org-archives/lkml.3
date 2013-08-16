Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab3HPEzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 00:55:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:48831 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab3HPEzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 00:55:38 -0400
Message-ID: <1376628601.4255.138.camel@pasglop>
Subject: Re: [RFC PATCH 3/4] powerpc: refactor of_get_cpu_node to support
 other architectures
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au, linux@openrisc.net,
        linuxppc-dev@lists.ozlabs.org, Jonas Bonn <jonas@southpole.se>,
        Michal Simek <monstr@monstr.eu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Date: Fri, 16 Aug 2013 14:50:01 +1000
In-Reply-To: <1376586580-5409-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376586580-5409-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-15 at 18:09 +0100, Sudeep KarkadaNagesha wrote:
>                /* Check for ibm,ppc-interrupt-server#s. If it doesn't exist
>                  * fallback to "reg" property and assume no threads
>                  */
> -

Oh and I forgot ... that comment is now wrong, since your code handles
threads in the "reg" case...

Cheers,
Ben.


