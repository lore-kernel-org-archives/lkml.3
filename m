Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3COTnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:43:19 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:61034 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab3COTnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:43:18 -0400
Date: Fri, 15 Mar 2013 20:42:23 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johan Hovold <jhovold@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] TTY: port hangup and close fixes
Message-ID: <20130315194223.GJ28843@localhost>
References: <51361724.4050107@suse.cz>
 <1362668153-10972-1-git-send-email-jhovold@gmail.com>
 <20130315190558.GA16118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315190558.GA16118@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 12:05:58PM -0700, Greg KH wrote:
> On Thu, Mar 07, 2013 at 03:55:47PM +0100, Johan Hovold wrote:
> > These patches against 3.9-rc1 fix a few issues with tty-port hangup and
> > close.
> 
> Are these for 3.9-final?

I'd say it can wait for 3.10 as it fixes long-standing issues without
any really severe consequences: DTR is being raised or dropped when it
shouldn't, some possibly annoying delays when open fails, and the
callbacks after disconnect that we get in usb-serial that we are already
work around.

Johan
