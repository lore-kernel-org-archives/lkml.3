Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaLWFw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 00:52:28 -0500
Received: from ozlabs.org ([103.22.144.67]:59168 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaLWFw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 00:52:27 -0500
Message-ID: <1419313945.30550.9.camel@ellerman.id.au>
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
Date: Tue, 23 Dec 2014 16:52:25 +1100
In-Reply-To: <1419302677.4364.100.camel@smoke>
References: <1419087601-4889-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <1419269161.3786.4.camel@infradead.org>
	 <1419294380.30550.1.camel@ellerman.id.au> <1419302677.4364.100.camel@smoke>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-22 at 18:44 -0800, Geoff Levand wrote:
> Hi Michael,
> 
> On Tue, 2014-12-23 at 11:26 +1100, Michael Ellerman wrote:
> > On Mon, 2014-12-22 at 09:26 -0800, Geoff Levand wrote:
> > > ps3_repository_write_highmem_info() is needed by otheros++.  What we
> > > need is a kernel patch to add the highmem info to the repository once it
> > > is known.
> > 
> > OK so where's that patch?
> 
> I put one in my ps3-linux repo.  I'll post it after I do some more
> testing.

Great, thanks.

cheers


