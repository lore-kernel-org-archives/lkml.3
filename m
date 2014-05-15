Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbaEOS0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:26:01 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:38511 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbaEOSZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:25:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140515140856.GA17453@kroah.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
	<20140515013245.GA1764@kroah.com>
	<1400120251.7699.11.camel@canyon.ip6.wittsend.com>
	<20140515031527.GA146352@ubuntu-hedt>
	<20140515040032.GA6702@kroah.com>
	<1400161337.7699.33.camel@canyon.ip6.wittsend.com>
	<20140515140856.GA17453@kroah.com>
Date: Thu, 15 May 2014 20:25:58 +0200
Message-ID: <CAFLxGvwfbVdLUq0NrSrQNYH+bTzYLuCE2moooHH319qRfDkS6Q@mail.gmail.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user namespaces
From: Richard Weinberger <richard.weinberger@gmail.com>
To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>
Cc: "Michael H. Warfield" <mhw@wittsend.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 4:08 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> Then don't use a container to build such a thing, or fix the build
> scripts to not do that :)

I second this.
To me it looks like some folks try to (ab)use Linux containers
for purposes where KVM would much better fit in.
Please don't put more complexity into containers. They are already
horrible complex
and error prone.

-- 
Thanks,
//richard
