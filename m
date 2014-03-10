Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaCJS5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:57:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:52542 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaCJS5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:57:35 -0400
Date: Mon, 10 Mar 2014 19:57:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
In-Reply-To: <1394476346.12752.43.camel@x220>
Message-ID: <alpine.DEB.2.02.1403101956250.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>  <1394447253.2979.12.camel@x220>  <alpine.DEB.2.02.1403101504590.18573@ionos.tec.linutronix.de>  <1394465314.12752.18.camel@x220>  <alpine.DEB.2.02.1403101757320.18573@ionos.tec.linutronix.de>
 <1394476346.12752.43.camel@x220>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014, Paul Bolle wrote:
> 
> Or is there a way to handle the "SMI nonsense" (whatever that may be)?

No, there is none. That's "value add" from the BIOS/board manufacturer
which utilizes the System Management Interrupt and steals CPU time
from the OS.

Thanks,

	tglx
