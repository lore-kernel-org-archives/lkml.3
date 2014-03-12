Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbaCLPaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:30:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbaCLPav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:30:51 -0400
Date: Wed, 12 Mar 2014 08:31:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>,
        jjhiblot@traphandler.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, b.brezillon@overkiz.com
Subject: Re: [PATCH RESEND] usb: at91-udc: fix irq and iomem resource
 retrieval
Message-ID: <20140312153140.GA8141@kroah.com>
References: <1390488102-8548-1-git-send-email-jjhiblot@traphandler.com>
 <1392210209-22142-1-git-send-email-nicolas.ferre@atmel.com>
 <532075EC.7060809@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532075EC.7060809@atmel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 03:57:48PM +0100, Nicolas Ferre wrote:
> On 12/02/2014 14:03, Nicolas Ferre :
> > From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> > 
> > When using dt resources retrieval (interrupts and reg properties) there is
> > no predefined order for these resources in the platform dev resource
> > table. Also don't expect the number of resource to be always 2.
> > 
> > Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> > Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Cc: stable <stable@vger.kernel.org> # 3.4
> 
> Gentle ping, after having resent the patch itself.

It helps if you send it to the correct maintainer, remember,
scripts/get_maintainer.pl is your friend...
