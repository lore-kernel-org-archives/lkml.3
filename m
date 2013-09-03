Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab3ICRcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:32:25 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:35670 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab3ICRcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:32:24 -0400
Message-ID: <52261D26.7060206@tilera.com>
Date: Tue, 3 Sep 2013 13:32:22 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v2] tile: support KVM for tilegx
References: <52091682.8020004@siemens.com> <201308122037.r7CKbo99011833@farm-0021.internal.tilera.com> <20130825113953.GN8218@redhat.com> <521AAED7.4080407@tilera.com> <20130826120445.GD8218@redhat.com>
In-Reply-To: <20130826120445.GD8218@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/2013 8:04 AM, Gleb Natapov wrote:
> On Sun, Aug 25, 2013 at 09:26:47PM -0400, Chris Metcalf wrote:
>> On 8/25/2013 7:39 AM, Gleb Natapov wrote:
>>> On Mon, Aug 12, 2013 at 04:24:11PM -0400, Chris Metcalf wrote:
>>>> This change provides the initial framework support for KVM on tilegx.
>>>> Basic virtual disk and networking is supported.
>>>>
>>> This needs to be broken down to more reviewable patches.

Ping!  I'd like to ask Linus to pull the tile tree now that 3.12 is open.
Let me know if this would be problematic for you.  

I think the tile KVM bits are in good enough shape that it makes sense
to pull them, and if there are follow-up concerns they can be addressed
later in the 3.12-rc series, or in future kernel releases.

In particular, it's probably worth noting the one generic change in the
series, which is adding a KVM_EXIT_AGAIN value.  If this seems like it
might be problematic, I can pull it for now and leave it for later review;
it's basically just a performance optimization.

The v3 series is at:

https://lkml.org/lkml/2013/8/28/675
https://lkml.org/lkml/2013/8/28/672
https://lkml.org/lkml/2013/8/28/676

Thank you!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

