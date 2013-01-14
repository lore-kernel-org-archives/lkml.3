Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab3ANJs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:48:56 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56784 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986Ab3ANJsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 04:48:53 -0500
Message-ID: <50F3D481.4000806@imgtec.com>
Date: Mon, 14 Jan 2013 09:48:49 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: early init dt for earlyprintk (was Re: [RFC PATCH v1 25/31] ARC:
 [plat-arcfpga] Hooking up platform to ARC UART)
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-26-git-send-email-vgupta@synopsys.com> <201211071416.08012.arnd@arndb.de> <50F3B54D.7010801@synopsys.com>
In-Reply-To: <50F3B54D.7010801@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_14_09_48_52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet

On 14/01/13 07:35, Vineet Gupta wrote:
> 2. We really need a Documentation/dt-for-new-linux-arches.txt, as the existing
> refs - while very helpful - fail to mention subtleties such as you absolutely need
> a intc instance and a default irq domain ..... before the driver can start using
> the DT.

Sounds like a good idea. I'm curious about what you say about default
IRQ domains though. Do you mean irq_set_default_host? In what way is
that required to use DT?

Cheers
James

