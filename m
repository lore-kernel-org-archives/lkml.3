Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaHKW5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:57:08 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35601 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbaHKW5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:57:05 -0400
X-Sasl-enc: LP0JeRl2XuqxHZj9fHXKU7KwY+280Io/HSInbGSaDaPS 1407797822
Date: Tue, 12 Aug 2014 06:55:27 +0800
From: Greg KH <greg@kroah.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: stable@vger.kernel.org, Amos Kong <akong@redhat.com>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [3.16 stable PATCH 1/1] virtio-rng: fix multi-device startup
Message-ID: <20140811225527.GB10721@kroah.com>
References: <5ef3aa4ea1932b7655d9db5a0139b8a2922af0db.1407760907.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ef3aa4ea1932b7655d9db5a0139b8a2922af0db.1407760907.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 06:11:47PM +0530, Amit Shah wrote:
> This is a 3.16-only patch.  The linux.git fix is
> 5c06273401f2eb7b290cadbae18ee00f8f65e893, which fixes this issue in a
> different way.

Why "different"?  Why can't I take that original patch instead?  What is
different in this patch, and why?

thanks,

greg k-h
