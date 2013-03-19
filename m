Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625Ab3CSSRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:17:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56264 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933557Ab3CSSRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:17:12 -0400
Date: Tue, 19 Mar 2013 14:17:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sven Joachim <svenjoac@gmx.de>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Stephen Thirlwall <sdt@dr.com>
Subject: Re: [ 12/75] USB: EHCI: work around silicon bug in Intels EHCI
 controllers
In-Reply-To: <87mwtzjql4.fsf@turtle.gmx.de>
Message-ID: <Pine.LNX.4.44L0.1303191415580.1302-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013, Sven Joachim wrote:

> On 2013-03-18 22:06 +0100, Greg Kroah-Hartman wrote:
> 
> > 3.8-stable review patch.  If anyone has any objections, please let me know.
> 
> This patch breaks resume from suspend on my system if the following
> device is plugged in:
> 
> ,----
> | $ lsusb | head -n1
> | Bus 005 Device 002: ID 07d1:3c03 D-Link System AirPlus G DWL-G122 Wireless Adapter(rev.C1) [Ralink RT2571W]
> `----
> 
> The same problem exists in 3.9-rc3, FWIW.
> 
> Detailed lsusb output follows, I'll be happy to provide more information
> if needed.

In what way is resume broken?

Alan Stern

