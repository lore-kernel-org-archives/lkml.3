Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932Ab3CSUwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:52:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759Ab3CSUwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:52:20 -0400
Date: Tue, 19 Mar 2013 13:52:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yann Collet <yann.collet.73@gmail.com>
Cc: Chanho Min <chanho.min@lge.com>, "Darrick J. Wong" <djwong@us.ibm.com>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        Richard Weinberger <richard@nod.at>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Kyungsik Lee <kyungsik.lee@lge.com>, Chanho Min <chanho0207@gmail.com>
Subject: Re: [PATCH 0/2] lib,crypto: Add lz4 compressor module and crypto
 API
Message-Id: <20130319135217.7fe2cd4064f633c5220b6f65@linux-foundation.org>
In-Reply-To: <CADv+DGmM=rzXNpAe0vC7cQ8cKKSXh=TTzzer=65p73E6qCUkhA@mail.gmail.com>
References: <CAOAMb1D+h8BRu=YWQ9dJ3JN-5CmmDLjgq1mLnnCH9TELrPx2bw@mail.gmail.com>
	<20130314135738.99fe3f091af728c149ce53a2@linux-foundation.org>
	<CADv+DGmM=rzXNpAe0vC7cQ8cKKSXh=TTzzer=65p73E6qCUkhA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013 15:42:04 +0100 Yann Collet <yann.collet.73@gmail.com> wrote:

> Thanks for pointing that out.
> I've been looking into the document pointed by Andrew,
> and here is my understanding :
> 
>  Signed-off-by is a one-line, so in this case :
> 
> Signed-off-by: Yann Collet <yann.collet.73@gmail.com>
> 
> 
> or
> 
> Signed-off-by follows a declaration, in this case it might be :
> 
> Developer's Certificate of Origin 1.1
> 
>         By making a contribution to this project, I certify that:
> 
>         (a) The contribution was created in whole or in part by me and I
>             have the right to submit it under the open source license
>             indicated in the file;
> 
> 
> Signed-off-by: Yann Collet <yann.collet.73@gmail.com>
> 
> 
> 
> Is that correct ?
> Should it be sent within this mailing list, or somewhere else ?

That's just fine - thanks!
