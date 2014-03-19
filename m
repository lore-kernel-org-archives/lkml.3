Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523AbaCSDh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 23:37:59 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:63076 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaCSDh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 23:37:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140318201056.7b876394@nehalam.linuxnetplumber.net>
References: <1394680527-28970-1-git-send-email-mcgrof@do-not-panic.com>
 <1394680527-28970-2-git-send-email-mcgrof@do-not-panic.com> <20140318201056.7b876394@nehalam.linuxnetplumber.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 18 Mar 2014 20:37:35 -0700
X-Google-Sender-Auth: HYyH6VJWHbRUUS-obNQvbYQ0Tt4
Message-ID: <CAB=NE6UgOL_d3MYyhqiLAZw-TLsf4wDu3NTW3+Zv1rJ6Exkdhg@mail.gmail.com>
Subject: Re: [PATCH 1/3] bridge: preserve random init MAC address
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 8:10 PM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Wed, 12 Mar 2014 20:15:25 -0700
> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:
>
>> As it is now if you add create a bridge it gets started
>> with a random MAC address and if you then add a net_device
>> as a slave but later kick it out you end up with a zero
>> MAC address. Instead preserve the original random MAC
>> address and use it.
>
> What is supposed to happen is that the recalculate chooses
> the lowest MAC address of the slaves. If there are no slaves
> it might as well just calculate a new random value. There is
> not great merit in preserving the original defunct address.

OK I'll go and add some changes for this then.

  Luis
