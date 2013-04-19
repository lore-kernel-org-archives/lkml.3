Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab3DSRow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:44:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45963 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751310Ab3DSRov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:44:51 -0400
Message-ID: <1366393490.3901.32.camel@joe-AO722>
Subject: Re: [PATCH] usb: storage: Convert US_DEBUGP to usb_stor_dbg
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb <linux-usb@vger.kernel.org>,
        usb-storage <usb-storage@lists.one-eyed-alien.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 19 Apr 2013 10:44:50 -0700
In-Reply-To: <20130419173503.GA27495@kroah.com>
References: <Pine.LNX.4.44L0.1304171426460.1623-100000@iolanthe.rowland.org>
	 <1366254055.28609.61.camel@joe-AO722> <20130419173503.GA27495@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 10:35 -0700, Greg Kroah-Hartman wrote:
> On Wed, Apr 17, 2013 at 08:00:55PM -0700, Joe Perches wrote:
> > Use a more current logging style with dev_printk
> > where possible.
[]
> With your other patch applied, this one seems to not apply to my tree:

I'll respin and resubmit.

