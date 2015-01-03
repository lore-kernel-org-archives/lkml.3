Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbbACVlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 16:41:12 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbbACVlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 16:41:09 -0500
Message-ID: <54A861EA.1070607@nod.at>
Date: Sat, 03 Jan 2015 22:40:58 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Daniel Borkmann <dborkman@redhat.com>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86, um: actually mark system call tables readonly
References: <1420287070-23450-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1420287070-23450-1-git-send-email-dborkman@redhat.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.01.2015 um 13:11 schrieb Daniel Borkmann:
> Commit a074335a370e ("x86, um: Mark system call tables readonly") was
> supposed to mark the sys_call_table in UML as RO by adding the const,
> but it doesn't have the desired effect as it's nevertheless being placed
> into the data section since __cacheline_aligned enforces sys_call_table
> being placed into .data..cacheline_aligned instead. We need to use
> the ____cacheline_aligned version instead to fix this issue.

__ vs. ___ oh my...
I'll pick up this patch.

Thanks a lot Daniel!
//richard

