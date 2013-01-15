Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab3AOW13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:27:29 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50396 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab3AOW1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:27:13 -0500
MIME-Version: 1.0
In-Reply-To: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
Date: Tue, 15 Jan 2013 23:27:12 +0100
Message-ID: <CAFLxGvxWs79ZCigDtBfkdu0mMk8Cfm6xNzzPZkoPKT9pTc9zrA@mail.gmail.com>
Subject: Re: [PATCH 0/3] ELF executable signing and verification
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        zohar@linux.vnet.ibm.com, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 10:34 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Upon exec(), we determine if executable is signed. If it is, then locks
> down the pages in memory (using MAP_LOCKED) and verfies the signature.
> If signature does not match, process is killed. Unsigned processes
> don't get affected at all.

Also ptrace() should be disallowed on such a process created from a signed ELF.

-- 
Thanks,
//richard
