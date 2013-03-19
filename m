Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3CSAPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:15:54 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:38730 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab3CSAPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:15:53 -0400
Date: Mon, 18 Mar 2013 17:17:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, shangw@linux.vnet.ibm.com,
        linuxram@us.ibm.com
Subject: Re: [PATCH 0/2] Some cleanup in driver core
Message-ID: <20130319001708.GB13502@kroah.com>
References: <1362622966-20003-1-git-send-email-weiyang@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362622966-20003-1-git-send-email-weiyang@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 10:22:44AM +0800, Wei Yang wrote:
> These two patches do some cleanup in the driver core.

No they do not.

I understand the need to fix code, but please, do so if it is broken.
These patches don't help, and in fact, they hurt things.

Next time, if you wish to send me patches like this, please get someone
else at IBM, who is experienced, to ack them, before sending them on to
me.

greg k-h
