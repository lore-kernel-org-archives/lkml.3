Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaJUEit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:38:49 -0400
Received: from ozlabs.org ([103.22.144.67]:39008 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaJUEis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:38:48 -0400
In-Reply-To: <1412920428-29263-1-git-send-email-bobby.prani@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: powerpc: Wire up sys_bpf() syscall
Message-Id: <20141021043846.8E5D4140092@ozlabs.org>
Date: Tue, 21 Oct 2014 15:38:46 +1100 (AEDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 05:53:45 UTC, Pranith Kumar wrote:
> This patch wires up the new syscall sys_bpf() on powerpc.

Is there a test suite we can run to verify it works?

cheers
