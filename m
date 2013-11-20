Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab3KTAEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:04:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab3KTAEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:04:39 -0500
Date: Tue, 19 Nov 2013 16:04:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: amiettinen@nvidia.com
Cc: axboe@kernel.dk, davidlohr@hp.com, matt.fleming@intel.com, kzak@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: partitions: efi: Fix bound check
Message-Id: <20131119160438.f1cce64660ab5c545be8baa9@linux-foundation.org>
In-Reply-To: <20131115.191422.1787913255098350249.apm@brigitte.kvy.fi>
References: <20131115.191422.1787913255098350249.apm@brigitte.kvy.fi>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Nov 2013 19:14:22 +0200 (EET) Antti P Miettinen <amiettinen@nvidia.com> wrote:

> Use ARRAY_SIZE instead of sizeof to get proper max for label
> length.
> 
> Signed-off-by: Antti P Miettinen <amiettinen@nvidia.com>
> Reviewed-by: Hiroshi Doyu <hdoyu@nvidia.com>
> Tested-by: Hiroshi Doyu <hdoyu@nvidia.com>

When fixing a bug, please provide a description of the user-visible
impact of that bug.  This is so that others can decide which kernel
version(s) need the patch.  

Hiroshi Doyu tested this patch, so I assume there was some observable
misbehaviour to test.  Please fully describe that.

