Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbaGWQtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:49:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646AbaGWQtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:49:11 -0400
Date: Wed, 23 Jul 2014 09:49:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: stern@rowland.harvard.edu, mail@beyermatthias.de, hdegoede@redhat.com,
        sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] usb-core: Revert "usb-core: Remove Fix mes in file hcd.c"
Message-ID: <20140723164910.GA8319@kroah.com>
References: <1406120170-22983-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406120170-22983-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 08:56:10AM -0400, Sasha Levin wrote:
> Revert since the commit message is incorrect and the original author refuses
> to fix/maintain it because "it's in the kernel already".

How can someone "fix" a commit message that is already in the tree?  You
can't.  The code part is correct, so why introduce the issue back?

I understand your frustration at the original submitter (whom I have
personally kill-filed), but reverting the patch isn't going to do
anything good overall here, sorry.

greg k-h
