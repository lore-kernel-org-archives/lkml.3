Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983AbaD3Sk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:40:29 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:43822 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759085AbaD3Sk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:40:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WKyQbh9Eih05szW6708fVTNPgTe62SU5tC2dQkqwJApg@mail.gmail.com>
References: <1394680527-28970-1-git-send-email-mcgrof@do-not-panic.com>
 <1394680527-28970-2-git-send-email-mcgrof@do-not-panic.com>
 <20140318201056.7b876394@nehalam.linuxnetplumber.net> <20140320020540.GF28801@wotan.suse.de>
 <CAB=NE6WKyQbh9Eih05szW6708fVTNPgTe62SU5tC2dQkqwJApg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 30 Apr 2014 11:40:04 -0700
X-Google-Sender-Auth: Zwthb-83t0xzV5zCWBbhK_XrcjU
Message-ID: <CAB=NE6VZNiJaag7mzMxk02+EjXLoyK=Uwe+YK+M+54UcVV_AEw@mail.gmail.com>
Subject: Re: [PATCH 1/3] bridge: preserve random init MAC address
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 12:41 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> Stephen, I'd like to respin this series to address all pending
> feedback, I'd still like your feedback / call / judgement on this
> part. I'm fine either way, just wanted to ensure I highlight the
> reasoning of why I kept the original random MAC address.

Re-poke.

  Luis
