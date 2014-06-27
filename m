Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaF0RmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 13:42:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaF0RmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:42:17 -0400
Date: Fri, 27 Jun 2014 10:46:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Richard Leitner <richard.leitner@skidata.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: serial: replace hardcoded ttyGS with PREFIX
Message-ID: <20140627174628.GA1449@kroah.com>
References: <20140627133721.10ca6cab@lxbuild.skidata.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627133721.10ca6cab@lxbuild.skidata.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 01:37:21PM +0200, Richard Leitner wrote:
> Replace all hardcoded ttyGS strings with the PREFIX macro.

Why?

> Therefore the PREFIX definition is moved to u_serial.h.

Why?

> Furthermore the modified files are checkpatch.pl compliant now.

You are doing two different things here in the same patch.  Please split
it up into two different patches.

thanks,

greg k-h
