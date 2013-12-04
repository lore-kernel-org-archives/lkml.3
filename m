Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab3LDPcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:32:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab3LDPcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:32:53 -0500
Date: Wed, 4 Dec 2013 07:33:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: Re: [PATCHSET REPOST driver-core-next] kernfs: implement trusted.*
 xattr support
Message-ID: <20131204153357.GA13316@kroah.com>
References: <1385246402-1407-1-git-send-email-tj@kernel.org>
 <20131204152455.GP3158@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204152455.GP3158@htj.dyndns.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 10:24:55AM -0500, Tejun Heo wrote:
> FYI, these two patches still apply as-is on top of the current
> driver-core-next e756bc5670d0 ("kobject: fix kset sample error path").

Ick, sorry about that, thanks for the poke, I forgot about them (they
are burried in my "todo" mbox.  They aren't lost, I'll get to them
soon...

thanks,

greg k-h
