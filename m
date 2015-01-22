Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbbAVLgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:36:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbbAVLgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:36:16 -0500
Date: Thu, 22 Jan 2015 16:51:50 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-kernel@vger.kernel.org, arve@android.com, nnk@google.com,
        paul@paul-moore.com, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org, jmorris@namei.org
Subject: Re: [PATCH] Add security hooks to binder and implement the hooks for
 SELinux.
Message-ID: <20150122085150.GB1268@kroah.com>
References: <1421855650-22522-1-git-send-email-sds@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421855650-22522-1-git-send-email-sds@tycho.nsa.gov>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 10:54:10AM -0500, Stephen Smalley wrote:
> Add security hooks to the binder and implement the hooks for SELinux.
> The security hooks enable security modules such as SELinux to implement
> controls over binder IPC.  The security hooks include support for
> controlling what process can become the binder context manager
> (binder_set_context_mgr), controlling the ability of a process
> to invoke a binder transaction/IPC to another process (binder_transaction),
> controlling the ability of a process to transfer a binder reference to
> another process (binder_transfer_binder), and controlling the ability
> of a process to transfer an open file to another process (binder_transfer_file).
> 
> These hooks have been included in the Android kernel trees since Android 4.3.

Very interesting, I missed the fact that these were added in that tree,
thanks for digging it out and submitting it.

I'd like some acks from some Android developers before I take these.
Or, if it's easier for them to go through the security tree, that's fine
with me as well.

thanks,

greg k-h
