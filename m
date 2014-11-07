Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaKGOUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:20:00 -0500
Received: from down.free-electrons.com ([37.187.137.238]:59422 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751971AbaKGOT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:19:58 -0500
Date: Fri, 7 Nov 2014 15:19:54 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/11] memory: add Atmel EBI (External Bus Interface)
 driver
Message-ID: <20141107151954.4d70a444@bbrezillon>
In-Reply-To: <20141107134112.GB4068@piout.net>
References: <1415203287-21517-1-git-send-email-boris.brezillon@free-electrons.com>
	<20141107134112.GB4068@piout.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2014 14:41:12 +0100
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> On 05/11/2014 at 17:01:16 +0100, Boris Brezillon wrote :
> > Arnd, you've commented the first version of this driver (IIRC, you
> > focused on the DT binding part), could you give your feedback on this
> > version (I based the new DT binding on TI's aemif driver).
> > 
> 
> Shouldn't you Cc Arnd then? ;)

I bounced the series a few minutes after realizing I had forgotten to
add him in Cc ;-)



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
