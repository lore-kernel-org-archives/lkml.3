Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaHTPc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:32:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaHTPcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:32:25 -0400
Date: Wed, 20 Aug 2014 17:30:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>, David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, richard@nod.at,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel: signal: NULL ptr deref when killing process
Message-ID: <20140820153009.GA14178@redhat.com>
References: <53F48402.4080302@oracle.com> <20140820141252.GA27301@redhat.com> <20140820150619.GA12706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820150619.GA12706@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Oleg Nesterov wrote:
>
> Hmm. I'll recheck and report tomorrow, but it seems that I found a bug:
> bad_fork_free_pid()->free_pid() looks wrong.

No, sorry for noise, I was wrong.

> David, any other reason why ->real_cred can be NULL ? (assuming that I interpret
> this asm correctly).

Oleg.

