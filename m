Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3FNOZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:25:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50878 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3FNOZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:25:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH v4] irqchip: Add support for ARMv7-M's NVIC
Date: Fri, 14 Jun 2013 16:24:36 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <1371073835-10639-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1371073835-10639-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201306141624.36978.arnd@arndb.de>
X-Provags-ID: V02:K0:tmFYzqPfhgfZikGfHTvipJ9GMVCjIWxjInTPVjp+gPi
 LIwtBHyXish2I5XX2PKkAgSU3///DF4dbWUvd3cMOwlSgOtIR5
 /A0u+G4HEQi+jUXrlexv+oxwqbAXQTsp7k6oQDCBQdIS/VXyRM
 TmCGP65x20QpXDdP/ci4iCLh29JKolq+f0v9UH7ydk7nhiPgu9
 S66aM2IbWVf4lgKZ370RMhL3RY/IyJxFsc9QNErAgnzwcBcext
 VhknH2WCNKDpKh+YjO8r1awbzMUs170kSPthfFG1ozOmm2H5aM
 o1UG1UNR6jW5DupiGG9v1DvdL0wuDVxGBVD59uGLJhp2WbGTtk
 raKTW2Vvp5mh2YhDO/es=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 June 2013, Uwe Kleine-König wrote:
> This interrupt controller is found on Cortex-M3 and Cortex-M4 machines.
> 
> Support for this controller appeared in Catalin's Cortex tree based on
> 2.6.33 but was nearly completely rewritten.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Wow, I hadn't followed the details of the generic irqchip patches, but
this looks great, almost no code left at all!

Acked-by: Arnd Bergmann <arnd@arndb.de>
