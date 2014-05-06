Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934439AbaEFIcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:32:24 -0400
Received: from canardo.mork.no ([148.122.252.1]:41933 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934253AbaEFIcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:32:20 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Andi Kleen <andi@firstfloor.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 19/24] net, diet: Make RPS configurable
Organization: m
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
	<1399328773-6531-20-git-send-email-andi@firstfloor.org>
Date: Tue, 06 May 2014 10:32:03 +0200
In-Reply-To: <1399328773-6531-20-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 5 May 2014 15:26:08 -0700")
Message-ID: <87oazbux30.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> Multiple receive queues are not needed on small systems,
> so allow disabling them.
>
> This is already disabled with !SMP, but it also makes
> sense to disable on very small SMP systems (like
> dual core SOC)

Such a pointless design still doesn't mean that you *have* to enable
SMP, does it?  How much would you save all over the kernel by simply
disabling SMP?

As for the system design: It seems to me that it would be more useful to
replace one of the CPU cores with some RAM...


Bjørn
