Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaBNT7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 14:59:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:44281 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaBNT7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 14:59:15 -0500
Date: Fri, 14 Feb 2014 20:59:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
In-Reply-To: <52FE6DEF.1050607@zytor.com>
Message-ID: <alpine.DEB.2.02.1402142030240.21991@ionos.tec.linutronix.de>
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5683.6030708@zytor.com> <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5BB6.9070405@zytor.com> <1051d374173243b2828efcd21f60ac36@DB4PR04MB265.eurprd04.prod.outlook.com>
 <52FE5D91.6060005@zytor.com> <alpine.DEB.2.02.1402141917320.21991@ionos.tec.linutronix.de> <52FE5ED4.4040508@zytor.com> <alpine.DEB.2.02.1402141924170.21991@ionos.tec.linutronix.de> <a1204336-ad8d-4f2f-8078-24f043f123e6@email.android.com>
 <alpine.DEB.2.02.1402142013150.21991@ionos.tec.linutronix.de> <52FE6DEF.1050607@zytor.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, H. Peter Anvin wrote:
> On 02/14/2014 11:15 AM, Thomas Gleixner wrote:
> > I'm fine with ACPI tables if we can provide simple means for embedded
> > users to load one via grub or just attach it to the kernel image.
> 
> That already exists, see Documentation/acpi/initrd_table_override.txt.

That requires, that you have already ACPI tables.

ACPI_SIG_RSDP cannot be overridden and that's the base table you need
to get ACPI going in the first place. So we need support for that and
probably for storing the tables at some non canonical place.

Thanks,

	tglx


