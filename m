Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaLWA0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 19:26:23 -0500
Received: from ozlabs.org ([103.22.144.67]:53333 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaLWA0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 19:26:22 -0500
Message-ID: <1419294380.30550.1.camel@ellerman.id.au>
Subject: Re: [PATCH] arch: powerpc: platforms: ps3: repository.c:  Remove
 unused function
From: Michael Ellerman <mpe@ellerman.id.au>
To: Geoff Levand <geoff@infradead.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Andre Heider <a.heider@gmail.com>,
        Nathan Whitehorn <nwhitehorn@freebsd.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 23 Dec 2014 11:26:20 +1100
In-Reply-To: <1419269161.3786.4.camel@infradead.org>
References: <1419087601-4889-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <1419269161.3786.4.camel@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-22 at 09:26 -0800, Geoff Levand wrote:
> On Sat, 2014-12-20 at 16:00 +0100, Rickard Strandqvist wrote:
> > Remove the function ps3_repository_write_highmem_info() that is not used anywhere.
> 
> NAK
> 
> ps3_repository_write_highmem_info() is needed by otheros++.  What we
> need is a kernel patch to add the highmem info to the repository once it
> is known.

OK so where's that patch?

> These ps3_repository_write_highmem routines are also the only
> documentation the freeBSD port has as to how the highmem info is (should
> be) saved in the repository.

We don't carry dead code as documentation for BSD.

cheers


