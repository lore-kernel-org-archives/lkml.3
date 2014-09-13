Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaIMQxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 12:53:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36518 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaIMQxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 12:53:43 -0400
Date: Sat, 13 Sep 2014 12:53:41 -0400 (EDT)
Message-Id: <20140913.125341.1440485569100220563.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH 1/3] virtio_net: pass well-formed sgs to
 virtqueue_add_*()
From: David Miller <davem@davemloft.net>
In-Reply-To: <87ioksgjt8.fsf@rustcorp.com.au>
References: <1410396458-1165-2-git-send-email-rusty@rustcorp.com.au>
	<20140912.175440.1013837932148725302.davem@davemloft.net>
	<87ioksgjt8.fsf@rustcorp.com.au>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Sep 2014 09:53:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 13 Sep 2014 15:10:03 +0930

> David Miller <davem@davemloft.net> writes:
>> Do you guys want me to take this series directly into net-next?
> 
> Actually, yes.  Since I'm going to be travelling, that makes it much
> easier for me.  And no other patches I have depend on it.

Series applied, but can you be more careful when you hand edit patches
or whatever you are doing that puts space characters at the beginning
of lines before TAB characters?

GIT flags this immediately, so even if you are hella lazy just feeding
your patches into "git am" will show this.

Thanks.
