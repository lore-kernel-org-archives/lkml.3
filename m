Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaLSUFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 15:05:20 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:34590 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaLSUFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 15:05:18 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/IPUAh9UnIVl/telwcorUu
Date: Fri, 19 Dec 2014 12:02:30 -0800
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: sfr@canb.auug.org.au, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: add the omap-pending tree
Message-ID: <20141219200230.GJ23854@atomide.com>
References: <alpine.DEB.2.02.1412191715230.3102@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1412191715230.3102@utopia.booyaka.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [141219 11:30]:
> 
> Hi Stephen,
> 
> Might you be willing to include this branch in your linux-next builds?
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/pjw/omap-pending.git#for-next
> 
> It will include OMAP clock, bus architecture, and low-level power 
> management patches that are planned to be included in pull requests to the 
> OMAP upstream maintainer, Tony Lindgren.  He in turn will submit pull 
> requests to the arm-soc tree.  The objective in including this branch is 
> to get these patches integration-tested earlier than they would be 
> otherwise.

Makes sense to me. The delay in getting omap stuff into Linux next
via arm-soc for-next is just too long because of the large number
of pending pull requests for various ARM SoCs.

While at it, can you please also (re-)add omap for-next too:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git#for-next

Regards,

Tony
