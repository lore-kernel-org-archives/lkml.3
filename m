Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947559Ab3BIAaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:30:05 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37492 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1947344Ab3BIAaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:30:00 -0500
Message-ID: <1360369799.13487.5.camel@joe-AO722>
Subject: Other alloc/OOM message question
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Fri, 08 Feb 2013 16:29:59 -0800
In-Reply-To: <20130208.174500.1518593039138341685.davem@davemloft.net>
References: <1360273587.27863.15.camel@joe-AO722>
	 <20130208.174500.1518593039138341685.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-08 at 17:45 -0500, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Thu, 07 Feb 2013 13:46:27 -0800
> > alloc failures already get standardized OOM
> > messages and a dump_stack.

Does anyone know if all the other alloc's like
dma_alloc_coherent, dma_alloc_noncoherent,
pci_alloc_consistent always produce OOM messages
via page_alloc/warn_alloc_failed for all arches?

If so, there are many more of these OOM messages
that could be removed.


