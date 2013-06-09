Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3FIPfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 11:35:45 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54129 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364Ab3FIPfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 11:35:44 -0400
Date: Sun, 9 Jun 2013 17:35:30 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH v3 08/27] x86, irq: kill create_irq()
Message-ID: <20130609153530.GE2245@breakpoint.cc>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
 <1370644273-10495-9-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370644273-10495-9-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:30:54PM -0700, Yinghai Lu wrote:
> create_irq() will return -1 when failing to allocate.
> create_irq_nr() will return 0 when failing to allocate.
> 
> It only causes confusion.
> 
> Now we have no user for create_irq(), so remove create_irq() for x86.

Oh thank you so much. That is what I just asked for :)

Sebastian
