Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945986Ab3BGW6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:58:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:49983 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945894Ab3BGW6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:58:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,625,1355126400"; 
   d="scan'208";a="254010774"
Date: Thu, 7 Feb 2013 23:58:09 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 07/11] mei: bus: Implement bus driver data
 setter/getter
Message-ID: <20130207225809.GG5072@sortiz-mobl>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
 <1360270997-7639-8-git-send-email-tomas.winkler@intel.com>
 <201302072238.44578.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302072238.44578.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 10:38:44PM +0000, Arnd Bergmann wrote:
> On Thursday 07 February 2013, Tomas Winkler wrote:
> > 
> > +inline void *mei_bus_get_clientdata(const struct mei_bus_client *client)
> > +{
> > +       return dev_get_drvdata(&client->dev);
> > +}
> > +EXPORT_SYMBOL(mei_bus_get_clientdata);
> > +
> 
> Did you really mean to export an inline function?
> 
> Can you make this a static inline function in a header file instead?
Sure, will do.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
