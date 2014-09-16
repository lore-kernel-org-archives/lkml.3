Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaIPCeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:34:17 -0400
Received: from ozlabs.org ([103.22.144.67]:40786 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588AbaIPCeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:34:14 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH 1/3] virtio_net: pass well-formed sgs to virtqueue_add_*()
In-Reply-To: <20140913.125341.1440485569100220563.davem@davemloft.net>
References: <1410396458-1165-2-git-send-email-rusty@rustcorp.com.au> <20140912.175440.1013837932148725302.davem@davemloft.net> <87ioksgjt8.fsf@rustcorp.com.au> <20140913.125341.1440485569100220563.davem@davemloft.net>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 16 Sep 2014 10:18:15 +0930
Message-ID: <87wq94fl0w.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Sat, 13 Sep 2014 15:10:03 +0930
>
>> David Miller <davem@davemloft.net> writes:
>>> Do you guys want me to take this series directly into net-next?
>> 
>> Actually, yes.  Since I'm going to be travelling, that makes it much
>> easier for me.  And no other patches I have depend on it.
>
> Series applied, but can you be more careful when you hand edit patches
> or whatever you are doing that puts space characters at the beginning
> of lines before TAB characters?
>
> GIT flags this immediately, so even if you are hella lazy just feeding
> your patches into "git am" will show this.

Hmm, that was weird, thanks for the warning.  This patch is pretty old,
so maybe I did hand-hack it at one stage.

Cheers,
Rusty.
