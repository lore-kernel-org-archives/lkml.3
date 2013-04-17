Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3DQEIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 00:08:19 -0400
Received: from ozlabs.org ([203.10.76.45]:52454 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab3DQEIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 00:08:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, bhelgaas@google.com
Subject: Re: [PATCH] module: add kset_obj_exists() and use it
In-Reply-To: <20130416122653.GB31290@redhat.com>
References: <1365506529-8396-1-git-send-email-vfalico@redhat.com> <87y5cq6ei9.fsf@rustcorp.com.au> <20130411095537.GC21320@redhat.com> <87vc7o8r7o.fsf@rustcorp.com.au> <20130416122653.GB31290@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 17 Apr 2013 13:25:13 +0930
Message-ID: <87txn56cbi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Veaceslav Falico <vfalico@redhat.com> writes:
> Tested for a day on two reproducers on the latest upstream kernel, with the
> recent kobject fix a49b7e82 ("kobject: fix kset_find_obj() race with
> concurrent last kobject_put()") - it fixes the issue, no regressions met.

Thanks, I've included the fix in my modules-next tree.

I did not CC:stable, since concurrent unload and reload is not really a
normal condition.

Cheers,
Rusty.
