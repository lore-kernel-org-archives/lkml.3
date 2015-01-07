Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbbAGKef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:34:35 -0500
Received: from ozlabs.org ([103.22.144.67]:39424 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbbAGKeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:34:31 -0500
Date: Wed, 7 Jan 2015 21:34:28 +1100
From: Anton Blanchard <anton@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au,
        mmarek@suse.cz, akpm@linux-foundation.org, jbaron@akamai.com,
        peterz@infradead.org, liuj97@gmail.com, mingo@kernel.org,
        mgorman@suse.de, linuxppc-dev@lists.ozlabs.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] jump_label: Allow jump labels to be used in
 assembly
Message-ID: <20150107213428.5ddb2095@kryten>
In-Reply-To: <20150106174822.GA29629@home.goodmis.org>
References: <1420539628-17875-1-git-send-email-anton@samba.org>
	<20150106174822.GA29629@home.goodmis.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

> Have you tested this on other archs? Because just looking at x86, it
> doesn't seem that asm/jump_label.h can handle being called in
> assembly.

Since no one is including linux/jump_label.h in assembly yet, nothing
should break. We could however add __ASSEMBLY__ protection to all the
asm/jump_label.h files. Patches on the way.

Anton
