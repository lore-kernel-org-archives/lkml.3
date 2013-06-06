Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3FFPzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:55:48 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:20840 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3FFPzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:55:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+SJlknlyWvh9xNos1KTOoh
Date: Thu, 6 Jun 2013 08:55:41 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>, linux-omap@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Broken DM816x support in Linux 3.10-rc4
Message-ID: <20130606155541.GM3331@atomide.com>
References: <1370446156-11788-1-git-send-email-aida.mynzhasova@skitlab.ru>
 <alpine.DEB.2.02.1306060414580.15042@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306060414580.15042@utopia.booyaka.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [130605 21:22]:
> Hi,
> 
> also,
> 
> On Wed, 5 Jun 2013, Aida Mynzhasova wrote:
> 
> > Aida Mynzhasova (5):
> >   ARM: OMAP: AM33xx: multiple renames for early initialization
> 
> If this patch is what's responsible for all the file renaming, please drop 
> it.  Looks from the change summary that it's just useless churn (although 
> I haven't seen the patch here since it never made it to the lists)

Yes no reason for all the renaming, marketing names can be
whatever. For example, we have am/dm37xx too which is really
omap36xx.

Regards,

Tony
