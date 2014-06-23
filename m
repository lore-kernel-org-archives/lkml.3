Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaFWAmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 20:42:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44006 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbaFWAmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 20:42:06 -0400
X-Sasl-enc: DLQNF87gMlk5ERxnCFKjuL9+geMR+SN0UM7Boc8bFswC 1403484123
Date: Sun, 22 Jun 2014 20:41:54 -0400
From: Greg KH <greg@kroah.com>
To: Jerry Stralko <gerb.stralko@gmail.com>
Cc: linux-kernel@vger.kernel.org, swetland@google.com
Subject: Re: [PATCH] stagging: android: logger: code cleanup
Message-ID: <20140623004154.GA7035@kroah.com>
References: <1403463068-21850-1-git-send-email-gerb.stralko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403463068-21850-1-git-send-email-gerb.stralko@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2014 at 02:51:08PM -0400, Jerry Stralko wrote:
> Add the unlikey macro to the return value of nonseekable_open,
> since it always returns successfully.

That shouldn't be needed, gcc and the processor knows this already.
Don't use unusual unless you can measure it.

> Fixed up some checkpatch warnings.

Don't do more than one thing in a patch, please split this up.

greg k-h
