Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbaCDBFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 20:05:42 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:56578 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbaCDBFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 20:05:40 -0500
MIME-Version: 1.0
In-Reply-To: <1393886825-24323-1-git-send-email-mcgrof@do-not-panic.com>
References: <1393886825-24323-1-git-send-email-mcgrof@do-not-panic.com>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Mon, 3 Mar 2014 17:05:18 -0800
X-Google-Sender-Auth: PLxdtsMnKKuzAiFHAP2IygCoTFQ
Message-ID: <CAB=NE6XLe0jkMTP=SkFDhMaWiubHTj7zyJwbbOcoCkkhYpBpdA@mail.gmail.com>
Subject: Re: [RFC v3 0/6] networking: address root block upon initialization
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 2:46 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>

<-- snip -->

> As I tested using the root block preference I noticed that if a net_device
> slave under the bridge gets the designated root port prior to setting in
> userspace the root_block feature enabling the feature won't kick the
> bridge to remove that net_device from the designated port. I addressed
> that issue and also upkeeping the initial random MAC address given to
> the bridge as if othwerwise we'd end up with a zero MAC address bridge
> if we root block all ports. I have only done local tests I'd appreciate a
> bit more wide test coverage and review.


Stephen,

I should note that even if we discard patches 4-6 patches for an
alternative implementation patches 1-3 should still be applicable for
review. Let me know what you think of those.

  Luis
