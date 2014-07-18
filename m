Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbaGRBrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 21:47:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbaGRBrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 21:47:14 -0400
Date: Thu, 17 Jul 2014 18:47:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/7] test: add firmware_class loader test
Message-ID: <20140718014713.GA32594@kroah.com>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
 <1405373897-31671-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405373897-31671-3-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 02:38:12PM -0700, Kees Cook wrote:
> This provides a simple interface to trigger the firmware_class loader
> to test built-in, filesystem, and user helper modes. Additionally adds
> tests via the new interface to the selftests tree.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  lib/Kconfig.debug                                 |   13 +++
>  lib/Makefile                                      |    1 +
>  lib/test_firmware.c                               |  117 +++++++++++++++++++++

Side note, I find it odd that in-kernel test modules are in lib/.

But whatever, you aren't the one that did this first, so I'm not going
to object here, I'll apply this, nice work.

thanks,

greg k-h
