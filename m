Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaBSXfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 18:35:34 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33606 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaBSXfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 18:35:32 -0500
Date: Wed, 19 Feb 2014 23:35:11 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: locking changes in tty broke low latency feature
Message-ID: <20140219233511.2467cdc8@alan.etchedpixels.co.uk>
In-Reply-To: <20140219230623.736E8406062@ip-64-139-1-69.sjc.megapath.net>
References: <20140219130308.GC1851@redhat.com>
	<20140219230623.736E8406062@ip-64-139-1-69.sjc.megapath.net>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> gpsd uses TIOCMIWAIT to get a wakeup from a PPS signal connected to a modem 
> control line.  That path might have the same problem and/or some ideas on how 
> to handle the data case.

TIOCMIWAIT should be fine. The data processing is deferred but very few
devices defer processing of modem change events.

Alan
