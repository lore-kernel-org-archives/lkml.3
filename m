Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaLaH5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 02:57:52 -0500
Received: from mail.eperm.de ([89.247.134.16]:51109 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbaLaH5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 02:57:50 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v6 4/4] crypto: AF_ALG: enable RNG interface compilation
Date: Wed, 31 Dec 2014 08:57:36 +0100
Message-ID: <18935950.yYgBXEvjNf@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.7-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141229104158.GB13699@gondor.apana.org.au>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de> <1531939.gTKbxagG6Z@tachyon.chronox.de> <20141229104158.GB13699@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 29. Dezember 2014, 21:41:58 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Dec 25, 2014 at 11:00:39PM +0100, Stephan Mueller wrote:
> > Enable compilation of the RNG AF_ALG support and provide a Kconfig
> > option to compile the RNG AF_ALG support.
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> Patch applied.

May I ask you to push the change so that I can create an AEAD Makefile/Kconfig 
patch that applies cleanly?


-- 
Ciao
Stephan
