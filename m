Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945933Ab3BGWzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:55:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:1677 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422669Ab3BGWzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:55:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,625,1355126400"; 
   d="scan'208";a="282379461"
Date: Thu, 7 Feb 2013 23:55:10 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 03/11] mei: bus: Initial implementation for I/O
 routines
Message-ID: <20130207225510.GD5072@sortiz-mobl>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
 <1360270997-7639-4-git-send-email-tomas.winkler@intel.com>
 <201302072234.44181.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302072234.44181.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Feb 07, 2013 at 10:34:44PM +0000, Arnd Bergmann wrote:
> On Thursday 07 February 2013, Tomas Winkler wrote:
> > +
> > +struct mei_bus_ops {
> > +       int (*send)(struct mei_bus_client *client, u8 *buf, size_t length);
> > +       int (*recv)(struct mei_bus_client *client, u8 *buf, size_t length);
> > +};
> > +
> 
> Can you have more than one set of mei_bus_ops in a driver? 
You can have at most one mei_bus_ops per mei_bus_client.

> If not, how about adding the callbacks to the mei_bus_driver structure
> directly as a simplification? 
I can add the ops directly to the mei_bus_client structure, yes.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
