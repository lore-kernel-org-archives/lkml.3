Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161604AbaDPOhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:37:50 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:57381 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161487AbaDPOhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:37:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140416.085743.1614257692560892039.davem@davemloft.net>
References: <CALCETrURHNmLyccRiF_W8o2ozRMR4AaCjUE=_PU8z1+Pq6X2jQ@mail.gmail.com>
 <20140416002010.GA5035@redhat.com> <CALCETrWzHYN3kKcmDTFDfGhZqE4u9+6XDtiOu5nncbK_7KKH0g@mail.gmail.com>
 <20140416.085743.1614257692560892039.davem@davemloft.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 16 Apr 2014 07:37:26 -0700
Message-ID: <CALCETrVv8SPM5xjOVGy7qO2aq3FKtG2uG57J49nO7Wy0-gg0Ew@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing cgroup path
To: David Miller <davem@davemloft.net>
Cc: Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter@redhat.com, Simo Sorce <ssorce@redhat.com>,
        cgroups@vger.kernel.org, kay@redhat.com,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 5:57 AM, David Miller <davem@davemloft.net> wrote:
>
> Please, just stop.

No.

This thread is proposing an ABI.  This means that, if the ABI ends up
in Linus's kernel, then it has to be supported forever.  Now is the
time to find and fix any issues with it before they become much harder
to fix.

This ABI is especially tricky because programs will use it even if
they don't explicitly try to.  So just adding the ABI may break
existing assumptions that are relevant to security or correctness.

--Andy
