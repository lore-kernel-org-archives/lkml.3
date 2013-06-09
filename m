Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3FIPxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 11:53:09 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54159 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364Ab3FIPxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 11:53:07 -0400
Date: Sun, 9 Jun 2013 17:52:51 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v3 09/27] x86, irq: Convert irq_2_pin list to generic list
Message-ID: <20130609155251.GF2245@breakpoint.cc>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
 <1370644273-10495-10-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370644273-10495-10-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:30:55PM -0700, Yinghai Lu wrote:
> Now irq_2_pin list is own grown list.
> We can use generic list to replace it so we could use generic helper
> functions to operate it.

Nice.

Sebastian
