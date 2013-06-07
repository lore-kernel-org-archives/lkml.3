Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab3FGFmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:42:11 -0400
Received: from 1wt.eu ([62.212.114.60]:36107 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab3FGFmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:42:09 -0400
Date: Fri, 7 Jun 2013 07:41:55 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anderson Lizardo <anderson.lizardo@openbossa.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: Re: [ 097/184] Bluetooth: Fix incorrect strncpy() in
Message-ID: <20130607054155.GI14633@1wt.eu>
References: <20130604172134.330397379@1wt.eu> <1370580807.4021.73.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370580807.4021.73.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 05:53:27AM +0100, Ben Hutchings wrote:
> On Tue, 2013-06-04 at 19:23 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> >  hidp_setup_hid()
> > 
> > From: Anderson Lizardo <anderson.lizardo@openbossa.org>
> 
> This is missing the upstream reference.  It was commit
> 0a9ab9bdb3e891762553f667066190c1d22ad62b.

Fixed, thank you !

Willy

