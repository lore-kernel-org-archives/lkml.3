Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbaCDAcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 19:32:08 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52950 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbaCDAcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 19:32:06 -0500
Date: Mon, 3 Mar 2014 16:31:59 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC v3 4/6] bridge: enable root block during device
 registration
Message-ID: <20140303163159.365d763b@nehalam.linuxnetplumber.net>
In-Reply-To: <CAB=NE6VpjebGrqFe7Q4L-uM0rrKitY3fB2kq5qGko+C1Fivm0w@mail.gmail.com>
References: <1393886825-24323-1-git-send-email-mcgrof@do-not-panic.com>
	<1393886825-24323-5-git-send-email-mcgrof@do-not-panic.com>
	<20140303154330.238a20bc@nehalam.linuxnetplumber.net>
	<CAB=NE6VpjebGrqFe7Q4L-uM0rrKitY3fB2kq5qGko+C1Fivm0w@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2014 15:58:50 -0800
"Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:

> On Mon, Mar 3, 2014 at 3:43 PM, Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> > Doing this in priv flags bloats what is a limited resource (# of bits).  
> 
> Agreed. I tried to avoid it but saw no other option for addressing
> this during initialization properly without requirng a userspace
> upgrade.

Replacing one Xen hack for another doesn't seem like great progress.
I would rather see an API change as needed because there are other
things like setting STP parameters which might also want to be part
of initial device add.
