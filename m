Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaGIAfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 20:35:43 -0400
Received: from ozlabs.org ([103.22.144.67]:45152 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaGIAfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 20:35:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amit Shah <amit.shah@redhat.com>, Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/1] virtio: console: remove unnecessary null test before debugfs_remove_recursive
In-Reply-To: <20140630064603.GA27557@grmbl.mre>
References: <1404031293-5678-1-git-send-email-fabf@skynet.be> <20140630064603.GA27557@grmbl.mre>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 09 Jul 2014 09:53:50 +0930
Message-ID: <871ttv752h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah <amit.shah@redhat.com> writes:
> On (Sun) 29 Jun 2014 [10:41:33], Fabian Frederick wrote:
>> Fix checkpatch warning:
>> WARNING: debugfs_remove_recursive(NULL) is safe this check is probably not required
>> 
>> Cc: Amit Shah <amit.shah@redhat.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: virtualization@lists.linux-foundation.org
>> Signed-off-by: Fabian Frederick <fabf@skynet.be>
>
> Reviewed-by: Amit Shah <amit.shah@redhat.com>
>
> Rusty, can you pick this up please?

Applied.

Thanks,
Rusty.
