Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaKSCeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 21:34:50 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:65405 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbaKSCes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 21:34:48 -0500
MIME-Version: 1.0
In-Reply-To: <20141118065603.22544.88816.stgit@preeti.in.ibm.com>
References: <20141118065603.22544.88816.stgit@preeti.in.ibm.com>
From: Joel Stanley <joel@jms.id.au>
Date: Wed, 19 Nov 2014 13:04:27 +1030
X-Google-Sender-Auth: dgxiUe8GKJpWZE8fl5R4hYBlwB4
Message-ID: <CACPK8Xc7G6JgqPYUmGTx8O=a6jxMB0yf1weEraMBu8dcAJibuQ@mail.gmail.com>
Subject: Re: [PATCH] cpuidle/powernv: Re-enable fastsleep at boot time
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Michael Neuling <mikey@neuling.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Preeti,

On Tue, Nov 18, 2014 at 5:26 PM, Preeti U Murthy
<preeti@linux.vnet.ibm.com> wrote:
> Commit dcb18694 "Fix ipi on palmeto" disabled fastsleep at boot time.

I couldn't find this commit in any tree; upstream, mpe's next, nor powerkvm.

I remember testing this as a workaround for the palmetto, but I don't
recall sending it upstream.

Cheers,

Joel
