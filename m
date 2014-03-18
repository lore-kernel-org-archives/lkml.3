Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbaCRUbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:31:44 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:52956 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953AbaCRUbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:31:40 -0400
MIME-Version: 1.0
In-Reply-To: <1394680527-28970-1-git-send-email-mcgrof@do-not-panic.com>
References: <1394680527-28970-1-git-send-email-mcgrof@do-not-panic.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 18 Mar 2014 13:31:19 -0700
X-Google-Sender-Auth: WgljTt4KpbEVWs6qtncv5uiULqI
Message-ID: <CAB=NE6W4pSyCU+zFKQPVFoQy5s8KGx34nEepRS0MnhnJuwf0Mg@mail.gmail.com>
Subject: Re: [PATCH 0/3] bridge: few enhancements and small fixes
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 8:15 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> Here's a few fixes I've been carrying around. I've now tested them
> on as many systems / environments as I can. They should be ready.
>
> Luis R. Rodriguez (3):
>   bridge: preserve random init MAC address
>   bridge: trigger a bridge calculation upon port changes
>   bridge: fix bridge root block on designated port

Folks, let me know if there are any other questions or if you spot any
other possible issues.

  Luis
