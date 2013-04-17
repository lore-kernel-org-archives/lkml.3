Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3DQFeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 01:34:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab3DQFeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 01:34:16 -0400
Date: Wed, 17 Apr 2013 07:33:41 +0200
From: Veaceslav Falico <vfalico@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, bhelgaas@google.com
Subject: Re: [PATCH] module: add kset_obj_exists() and use it
Message-ID: <20130417053341.GA7195@redhat.com>
References: <1365506529-8396-1-git-send-email-vfalico@redhat.com>
 <87y5cq6ei9.fsf@rustcorp.com.au>
 <20130411095537.GC21320@redhat.com>
 <87vc7o8r7o.fsf@rustcorp.com.au>
 <20130416122653.GB31290@redhat.com>
 <87txn56cbi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87txn56cbi.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 01:25:13PM +0930, Rusty Russell wrote:
>Veaceslav Falico <vfalico@redhat.com> writes:
>> Tested for a day on two reproducers on the latest upstream kernel, with the
>> recent kobject fix a49b7e82 ("kobject: fix kset_find_obj() race with
>> concurrent last kobject_put()") - it fixes the issue, no regressions met.
>
>Thanks, I've included the fix in my modules-next tree.
>
>I did not CC:stable, since concurrent unload and reload is not really a
>normal condition.

Sounds great, thank you!

>
>Cheers,
>Rusty.
