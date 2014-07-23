Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296AbaGWSyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:54:09 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58239 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbaGWSyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:54:06 -0400
Date: Wed, 23 Jul 2014 19:53:32 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] firmware validation
Message-ID: <20140723195332.0bf0401c@alan.etchedpixels.co.uk>
In-Reply-To: <1405373897-31671-1-git-send-email-keescook@chromium.org>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014 14:38:10 -0700
Kees Cook <keescook@chromium.org> wrote:

> This creates a new LSM hook to validate the contents (and origin) of
> component firmware being provided to the kernel from userspace via the
> request_firmware() interface.
> 
> Additionally creates a test module and test cases for all of the existing
> interfaces as well as the new "fd" interface.

There is a specific reason that this is a good idea. On any system with
basic capabilities only anyone owning DAC capabilities can replace the
firmware file on disk. So for some devices DAC implies a route to RAWIO
which is not good.

Alan
