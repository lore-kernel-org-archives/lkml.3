Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbaLPLqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:46:18 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:41823 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaLPLqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:46:16 -0500
Date: Tue, 16 Dec 2014 12:46:14 +0100
From: Johan Hovold <johan@kernel.org>
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] usb: serial: handle -ENODEV and -EPROTO quietly
Message-ID: <20141216114614.GI6778@localhost>
References: <1418340594-30469-1-git-send-email-jmmahler@gmail.com>
 <20141215102321.GD6778@localhost>
 <20141215125305.GA18251@hudson.localdomain>
 <20141215163801.GB1470@kroah.com>
 <20141216071037.GA3487@newt.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216071037.GA3487@newt.localdomain>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:10:37PM -0800, Jeremiah Mahler wrote:

> Perhaps something at a lower level could return a more apt error number
> such as -ENODEV.  Then there would be no conflict with -EPROTO.

I'm afraid it's not possible to differentiate between a disconnected and
malfunctioning device in that short window before the disconnect is
reported and processes by the hub driver.

> I will look in to it again and re-submit the patches.

Let's see what comes out of this discussion first.

Thanks,
Johan
