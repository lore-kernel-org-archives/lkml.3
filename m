Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbaGRBsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 21:48:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122AbaGRBsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 21:48:17 -0400
Date: Thu, 17 Jul 2014 18:48:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/7] security: introduce kernel_fw_from_file hook
Message-ID: <20140718014816.GA603@kroah.com>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
 <1405373897-31671-4-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405373897-31671-4-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 02:38:13PM -0700, Kees Cook wrote:
> In order to validate the contents of firmware being loaded, there must be
> a hook to evaluate any loaded firmware that wasn't built into the kernel
> itself. Without this, there is a risk that a root user could load malicious
> firmware designed to mount an attack against kernel memory (e.g. via DMA).
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/linux/security.h |   16 ++++++++++++++++
>  security/capability.c    |    6 ++++++
>  security/security.c      |    6 ++++++
>  3 files changed, 28 insertions(+)

I would like an ack from a security developer/maintainer before applying
this patch...

thanks,

greg k-h
