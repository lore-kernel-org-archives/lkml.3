Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab3LEEgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 23:36:47 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:33981 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3LEEgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 23:36:46 -0500
Message-ID: <1386218201.7152.10.camel@host5.omatika.ru>
Subject: Re: [PATCH 01/11] resolve PXA<->8250 serial device address conflict
From: Sergei Ianovich <ynvich@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jiri Slaby <jslaby@suse.cz>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Date: Thu, 05 Dec 2013 08:36:41 +0400
In-Reply-To: <20131205043544.GA28580@kroah.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
	 <1385879185-22455-2-git-send-email-ynvich@gmail.com>
	 <20131202090253.GE3942@xps8300> <1385976238.12531.8.camel@host5.omatika.ru>
	 <20131202094932.GF3942@xps8300>
	 <1385980005.12531.21.camel@host5.omatika.ru>
	 <20131202141033.GK3942@xps8300> <20131205041251.GA24906@kroah.com>
	 <1386217896.7152.8.camel@host5.omatika.ru>
	 <20131205043544.GA28580@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 20:35 -0800, Greg Kroah-Hartman wrote:
> On Thu, Dec 05, 2013 at 08:31:36AM +0400, Sergei Ianovich wrote:
> > I'm reading the last message as a confirmation that
> > drivers/tty/serial/pxa.c needs to be rewritten using 8250_core.c.
> 
> Yes, how much work is this really?

Great. It seems two drivers practically match. I'll do and submit a
merge patch.

