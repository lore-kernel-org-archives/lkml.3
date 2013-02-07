Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945977Ab3BGW70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:59:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:6663 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945943Ab3BGW7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:59:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,625,1355126400"; 
   d="scan'208";a="288041770"
Date: Thu, 7 Feb 2013 23:59:22 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 01/11] mei: bus: Initial MEI bus type
 implementation
Message-ID: <20130207225922.GH5072@sortiz-mobl>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
 <1360270997-7639-2-git-send-email-tomas.winkler@intel.com>
 <201302072241.07171.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302072241.07171.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 10:41:06PM +0000, Arnd Bergmann wrote:
> On Thursday 07 February 2013, Tomas Winkler wrote:
> > +}
> > +EXPORT_SYMBOL(mei_add_device);
> > +
> > +void mei_remove_device(struct mei_bus_client *client)
> > +{
> > +       device_unregister(&client->dev);
> > +}
> > +EXPORT_SYMBOL(mei_remove_device);
> 
> One more point: did you intentionally pick EXPORT_SYMBOL over
> EXPORT_SYMBOL_GPL here? 
No, I didn't.

> It is your decision as the copyright
> holder, but the default is often EXPORT_SYMBOL_GPL these
> days, to make it clear that you don't expect closed source
> drivers to plug in there.
I'll fix that if Tomas is ok with it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
