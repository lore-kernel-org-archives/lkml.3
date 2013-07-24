Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3GXO6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:58:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3GXO6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:58:37 -0400
Date: Wed, 24 Jul 2013 07:59:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Balint Czobor <czoborbalint@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: misc: Add support for ANDROID_PMEM
Message-ID: <20130724145949.GD15095@kroah.com>
References: <1374662321-27152-1-git-send-email-czoborbalint@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374662321-27152-1-git-send-email-czoborbalint@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 12:38:41PM +0200, Balint Czobor wrote:
> Add initial support for Android pmem allocator.

Why is this needed?

> Signed-off-by: Balint Czobor <czoborbalint@gmail.com>

As I don't think you wrote this code, you need to put the proper
authorship information in the patch, and also you should cc: the needed
developers who worked on this code.

Also, didn't we delete this driver a while ago from the tree?

Yes, we did, look at commit b0d017e80e9f4e6b37e699b9a944646e64deb473.
Why do you want this back?

confused,

greg k-h
