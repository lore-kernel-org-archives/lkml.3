Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3IZH7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:59:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:44027 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab3IZH7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:59:46 -0400
Message-ID: <1380182336.28561.21.camel@pasglop>
Subject: Re: [PATCH 1/3] powerpc: Implement arch_get_random_long/int() for
 powernv
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        gleb@redhat.com, pbonzini@redhat.com, agraf@suse.de, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Date: Thu, 26 Sep 2013 17:58:56 +1000
In-Reply-To: <1380177066-3835-1-git-send-email-michael@ellerman.id.au>
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 16:31 +1000, Michael Ellerman wrote:
> +       pr_info_once("registering arch random hook\n");

Either pr_debug or make it nicer looking :-)

Cheers,
Ben.


