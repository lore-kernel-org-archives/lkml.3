Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaEYSD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 14:03:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaEYSD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 14:03:58 -0400
Date: Sun, 25 May 2014 11:03:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaitanya Hazarey <c@24.io>
Cc: chad@dahc.us, michael.banken@mathe.stud.uni-erlangen.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Silicom: bpctl_mod.c & bypass.c: Fixed a lot of
 checkpatch.pl warnings
Message-ID: <20140525180357.GA18332@kroah.com>
References: <1400909128-1409-1-git-send-email-c@24.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400909128-1409-1-git-send-email-c@24.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 10:25:28PM -0700, Chaitanya Hazarey wrote:
> Added a blank line after declarations in many places to fix the
> following warning issued by checkpatch.pl:
> 
> WARNING: Missing a blank line after declarations
> 
> Thanks Greg K-H and Dan for the patience. Hope it works this time, I did
> apply it against staging and it was ok. 


Hm, something is odd, it still doesn't apply properly:

$ p1 < ../s1
checking file drivers/staging/silicom/bpctl_mod.c
Hunk #40 FAILED at 4773.
Hunk #41 FAILED at 4821.
...
Hunk #89 FAILED at 7534.
3 out of 89 hunks FAILED

Can you refresh this against my tree again and resend?  I think we are
out of sync here still.

thanks,

greg k-h
