Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaEWSq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:46:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaEWSq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:46:57 -0400
Date: Fri, 23 May 2014 21:33:16 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Martin Kepplinger <martink@posteo.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: rtl8821ae: mark pci_mem_start (and _end) as
 __iomem
Message-ID: <20140523123316.GA6919@kroah.com>
References: <20140504002617.GA16403@kroah.com>
 <1399206139-16906-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399206139-16906-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2014 at 02:22:19PM +0200, Martin Kepplinger wrote:
> Shared addresses can be marked as such.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> I guess that's what you meant. Thanks for your feedback!

Yes, that is correct, but someone beat you to this patch, sorry :(
