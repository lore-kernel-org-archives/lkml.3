Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaLQIzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:55:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:53416 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaLQIzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:55:52 -0500
Date: Wed, 17 Dec 2014 09:55:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [patch 4/4] acpi: ioapic: Respect the resource flags
In-Reply-To: <54911823.3030602@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1412170955250.17382@nanos>
References: <20141211191853.613107396@linutronix.de> <20141211193112.813391696@linutronix.de> <CAE9FiQV4jArUDGuhb3o2BhiVGcGxSXhADU+5=NsdqJGQOo2oJQ@mail.gmail.com> <alpine.DEB.2.11.1412120847400.16494@nanos> <548AAB67.9050005@linux.intel.com>
 <alpine.DEB.2.11.1412121241200.16494@nanos> <54911823.3030602@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Jiang Liu wrote:

> Hi Thomas,
> 	Should I keep the development history or start from scratch
> for this ACPI resource patch set?

We better start from scratch.
