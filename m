Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab3GST5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:57:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3GST5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:57:19 -0400
Date: Fri, 19 Jul 2013 12:57:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 5/5] initmpfs v2: Use initramfs if rootfstype= or root=
 specified.
Message-Id: <20130719125718.2227f52ccf642dda060f0ae8@linux-foundation.org>
In-Reply-To: <1374018312.367663@landley.net>
References: <1374018312.366617@landley.net>
	<1374018312.367663@landley.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 16:45:39 -0700 (PDT) Rob Landley <rob@landley.net> wrote:

> Command line option rootfstype=ramfs to obtain old initramfs behavior,
> and use ramfs instead of tmpfs for stub when root= defined (for cosmetic
> reasons).

Could we get a Documentation/kernel-parameters.txt update please?
