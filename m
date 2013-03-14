Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab3CNU5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:57:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3CNU5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:57:40 -0400
Date: Thu, 14 Mar 2013 13:57:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chanho Min <chanho.min@lge.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        Richard Weinberger <richard@nod.at>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Yann Collet <yann.collet.73@gmail.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Chanho Min <chanho0207@gmail.com>
Subject: Re: [PATCH 0/2] lib,crypto: Add lz4 compressor module and crypto
 API
Message-Id: <20130314135738.99fe3f091af728c149ce53a2@linux-foundation.org>
In-Reply-To: <CAOAMb1D+h8BRu=YWQ9dJ3JN-5CmmDLjgq1mLnnCH9TELrPx2bw@mail.gmail.com>
References: <CAOAMb1D+h8BRu=YWQ9dJ3JN-5CmmDLjgq1mLnnCH9TELrPx2bw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Mar 2013 18:48:20 +0900 Chanho Min <chanho.min@lge.com> wrote:

> This patchset is for supporting LZ4 compression and the crypto API using it.
> This should be applied after the previous Kyungsik's "LZ4 compressed kernel"
> patches - https://lkml.org/lkml/2013/3/5/181.

Thanks.

Yann, it would be appreciated if you could give us your Signed-off-by:
as an indication of your approval for including this code into Linux. 
This is a bit of kernel legal bureaucracy which is explained at
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/SubmittingPatches?id=refs/tags/v3.9-rc2,
line 300.

