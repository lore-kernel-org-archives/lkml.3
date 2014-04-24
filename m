Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaDXX2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:28:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaDXX2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:28:00 -0400
Date: Thu, 24 Apr 2014 16:30:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] serial: uart: add hw flow control support configuration
Message-ID: <20140424233053.GB21443@kroah.com>
References: <1397243877-23234-1-git-send-email-m-karicheri2@ti.com>
 <3E54258959B69E4282D79E01AB1F32B70471B273@DFLE11.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E54258959B69E4282D79E01AB1F32B70471B273@DFLE11.ent.ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 02:31:51PM +0000, Karicheri, Muralidharan wrote:
> 
> Can this be queued up for merge if looks good?

Can you fix up the line Alan had questions about?

thanks,

greg k-h
