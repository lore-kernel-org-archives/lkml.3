Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab3CTEMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 00:12:34 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:42941 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3CTEMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 00:12:33 -0400
MIME-Version: 1.0
In-Reply-To: <51489979.2070403@draigBrady.com>
References: <5121C7AF.2090803@numascale-asia.com>
	<CAJd=RBArPT8YowhLuE8YVGNfH7G-xXTOjSyDgdV2RsatL-9m+Q@mail.gmail.com>
	<51254AD2.7000906@suse.cz>
	<CAJd=RBCiYof5rRVK+62OFMw+5F=5rS=qxRYF+OHpuRz895bn4w@mail.gmail.com>
	<512F8D8B.3070307@suse.cz>
	<CAJd=RBD=eT=xdEy+v3GBZ47gd47eB+fpF-3VtfpLAU7aEkZGgA@mail.gmail.com>
	<5138EC6C.6030906@suse.cz>
	<CAJd=RBC6JzXzPn9OV8UsbEjX152RcbKpuGGy+OBGM6E43gourQ@mail.gmail.com>
	<513A7263.5090303@suse.cz>
	<51489979.2070403@draigBrady.com>
Date: Wed, 20 Mar 2013 12:12:32 +0800
Message-ID: <CAJd=RBCfMj7SUOE64KWXv6fcdASQWZV_Taujrtf4mDo8fFKBhw@mail.gmail.com>
Subject: Re: kswapd craziness round 2
From: Hillf Danton <dhillf@gmail.com>
To: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Daniel J Blueman <daniel@numascale-asia.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>, mm <linux-mm@kvack.org>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 12:59 AM, Pádraig Brady <P@draigbrady.com> wrote:
>
> I notice the same thunderbird issue on the much older 2.6.40.4-5.fc15.x86_64
> which I'd hoped would be fixed on upgrade :(
>
> My Thunderbird is using 1957m virt, 722m RSS on my 3G system.
> What are your corresponding mem values?
>
> For reference:
> http://marc.info/?t=130865025500001&r=1&w=2
> https://bugzilla.redhat.com/show_bug.cgi?id=712019
>
Hey, would you all please try Mels new work?
http://marc.info/?l=linux-mm&m=136352546814642&w=4

thanks
Hillf
