Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaJUEys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:54:48 -0400
Received: from ozlabs.org ([103.22.144.67]:56355 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaJUEyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:54:47 -0400
Message-ID: <1413867285.5498.2.camel@concordia>
Subject: Re: powerpc: Wire up sys_bpf() syscall
From: Michael Ellerman <mpe@ellerman.id.au>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 Oct 2014 15:54:45 +1100
In-Reply-To: <CAHj3AVnj4Etu71egZ30a-KHYdLHjd2S4J8TY0mjHX_Q+BLvLMA@mail.gmail.com>
References: <1412920428-29263-1-git-send-email-bobby.prani@gmail.com>
	 <20141021043846.8E5D4140092@ozlabs.org>
	 <CAHj3AVnj4Etu71egZ30a-KHYdLHjd2S4J8TY0mjHX_Q+BLvLMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 08:52 +0400, Denis Kirjanov wrote:
> We have a test suite under samples/bpf/

Thanks.

I looked under tools/testing/selftests, could it move in there?

cheers


