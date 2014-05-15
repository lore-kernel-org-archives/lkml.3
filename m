Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaEOUvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:51:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaEOUvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:51:52 -0400
Date: Thu, 15 May 2014 13:55:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Artem Fetishev <wwctrsrx@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drivers: staging: line6: Add blank lines after
 declarations
Message-ID: <20140515205511.GA2414@kroah.com>
References: <1400027584-6970-1-git-send-email-wwctrsrx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400027584-6970-1-git-send-email-wwctrsrx@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 03:33:04AM +0300, Artem Fetishev wrote:
> Use the more common kernel coding style.
> 
> Version #2 of this patch removes unnecesary blank line added in version #1.

This line isn't needed, it goes below the --- line.

Also, sorry, someone else sent a valid version of this patch before you
did, so your patch doesn't apply anymore :(

greg k-h
