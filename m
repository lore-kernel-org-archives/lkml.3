Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab3CYNRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:17:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:2924 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757729Ab3CYNRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:17:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,905,1355126400"; 
   d="scan'208";a="275600911"
Date: Mon, 25 Mar 2013 15:17:27 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ley Foon Tan <lftan@altera.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/3] serial: of_serial: Handle hw-flow-control property
Message-ID: <20130325131727.GB2847@xps8300>
References: <1364211286-31611-1-git-send-email-heikki.krogerus@linux.intel.com>
 <201303251247.58823.arnd@arndb.de>
 <20130325125757.GA2847@xps8300>
 <201303251304.47559.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303251304.47559.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 01:04:47PM +0000, Arnd Bergmann wrote:
> > > I still find the text in the binding and the name of the property confusing,
> > > because it seems to imply that you have no hardware flow control without this.
> > > I think what you mean here is really "automatic flow control" rather than
> > > "hardware flow control".
> > 
> > Ah, I understand. I'll change the property name to auto-flow-control.
> > 
> 
> Ok, sounds good. I would also suggest rewording the description in the
> binding so that the driver is allowed to detect the presence of the automatic
> flow control capability even if the property is not set, because that's
> what the driver does.

OK, I'll fix the description too.

Thanks,

-- 
heikki
