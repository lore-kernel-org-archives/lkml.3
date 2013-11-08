Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab3KHTdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:33:04 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:55904 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab3KHTdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:33:02 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1438803E-C904-428B-B042-891978BC15DF@codeaurora.org>
References: <1438803E-C904-428B-B042-891978BC15DF@codeaurora.org>
Date: Fri, 8 Nov 2013 11:33:00 -0800
Message-ID: <CAOesGMgyqXS8tq0Ru=ibypV89-oAJ8bzxhdFTnSAvfOobEC+Lw@mail.gmail.com>
Subject: Re: common location for devicetree files
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 3:21 PM, Kumar Gala <galak@codeaurora.org> wrote:
> As we start having more sharing of device trees between architectures (arm & arm64, arm & powerpc, guessing maybe mips & arm) we need dts to live in location that
>
> I was wondering what people felt about doing:
>
>         arch/dts/<VENDOR>/
>
> as a common location that could be shared.  I'm up for other suggestions.

dts isn't an architecture, so having it directly under arch/ doesn't
make sense. I know it's the first common parent of a lot of platforms
though.

I'd be ok with adding a toplevel dts/ directory for this, for lack of
better options. It doesn't really fit under firmware, lib, kernel,
scripts, tools...


-Olof
