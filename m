Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaEYWNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 18:13:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaEYWNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 18:13:11 -0400
Date: Sun, 25 May 2014 15:13:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaitanya Hazarey <c@24.io>
Cc: dan.carpenter@oracle.com, chad@dahc.us,
        michael.banken@mathe.stud.uni-erlangen.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Silicom: bpctl_mod.c & bypass.c: Fixed a lot of
 checkpatch.pl warnings
Message-ID: <20140525221310.GA26664@kroah.com>
References: <1401044348-15627-1-git-send-email-c@24.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401044348-15627-1-git-send-email-c@24.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 11:59:08AM -0700, Chaitanya Hazarey wrote:
> Added a blank line after declarations in many places to fix the following warning issued by checkpatch.pl:
> 
> WARNING: Missing a blank line after declarations
> 
> Lets see if this works now, this patch is prepared against Greg's staging tree.

What branch of my staging.git tree are you using?  You should use the
staging-next branch, this patch still doesn't apply to there :(

greg k-h
