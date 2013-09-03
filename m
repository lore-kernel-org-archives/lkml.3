Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab3ICIR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 04:17:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50943 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab3ICIRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 04:17:24 -0400
Date: Tue, 3 Sep 2013 11:17:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kumar Gaurav <kumargauravgupta3@gmail.com>
Cc: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v4:No Change] xHCI:Fixing xhci_readl definition and
 function call
Message-ID: <20130903081710.GE6329@mwanda>
References: <1377970365-5420-1-git-send-email-kumargauravgupta3@gmail.com>
 <522557B7.8080909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522557B7.8080909@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 08:59:59AM +0530, Kumar Gaurav wrote:
> I tried applying this patch on linux-next and it applies well.
> i used
>     git apply --apply
> 

The merge window is open.  No one is applying patches until -rc1 comes
out.

This one is not redone in the right way.  The subject is wrong:

 Bad: [PATCH v4:No Change] xHCI:Fixing xhci_readl definition and function call
Good: [PATCH v4] xHCI: Fixing xhci_readl definition and function call

There should be a note under the --- line to say what changed and why
you are resending.  It's not helpful to say "No Change" because actually
there were many changes.

---
v4: Update to apply on linux-next.

regards,
dan carpenter

