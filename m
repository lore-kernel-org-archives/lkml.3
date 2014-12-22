Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaLVR0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:26:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:39352 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbaLVR0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:26:13 -0500
Message-ID: <1419269161.3786.4.camel@infradead.org>
Subject: Re: [PATCH] arch: powerpc: platforms: ps3: repository.c:  Remove
 unused function
From: Geoff Levand <geoff@infradead.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Andre Heider <a.heider@gmail.com>,
        Nathan Whitehorn <nwhitehorn@freebsd.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Dec 2014 09:26:01 -0800
In-Reply-To: <1419087601-4889-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419087601-4889-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-12-20 at 16:00 +0100, Rickard Strandqvist wrote:
> Remove the function ps3_repository_write_highmem_info() that is not used anywhere.

NAK

ps3_repository_write_highmem_info() is needed by otheros++.  What we
need is a kernel patch to add the highmem info to the repository once it
is known.

These ps3_repository_write_highmem routines are also the only
documentation the freeBSD port has as to how the highmem info is (should
be) saved in the repository.

-Geoff


