Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3C0Vqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:46:47 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:36855 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab3C0Vqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:46:45 -0400
MIME-Version: 1.0
In-Reply-To: <5153620E.4010608@gmail.com>
References: <5153620E.4010608@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 27 Mar 2013 15:46:24 -0600
Message-ID: <CAErSpo6w+tTbwJ7Qinpd0Vx20q5cm2gMvqzE1Do+2=G3b8rcHA@mail.gmail.com>
Subject: Re: 3.8.4 kernel
To: "Joseph A. Millikan" <josephamillikan@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 3:18 PM, Joseph A. Millikan
<josephamillikan@gmail.com> wrote:
>
> We use Mint 11 32-bit and we've noticed with any kernel beyond 3.6.11, the
> Ethernet port stops responding to pings after 15 minutes and samba clients
> cease to receive data in realtime.  I hope this is the correct place to
> report this as we received a nasty, sullen response when posted with the
> Ubuntu folks (which we will NEVER do again.)
>
> If you aren't the proper party to whom we should direct this report, please
> disregard.  We were just trying to help developers if there is an
> undiscovered issue with Ethernet ports on Lenovo G770 laptops which our
> court uses with Mint 11.

What specific kernels have you tried?  It'd be surprising if such an
egregious issue went unnoticed for long, but if recent kernels like
3.8 or 3.9-rc are still broken, there's likely something we need to
fix.  Can you collect complete dmesg logs from 3.6.11 and the oldest
broken kernel you've found?  You might also run "watch cat
/proc/interrupts" in a window off to the side and see if the NIC
interrupt count stops increasing after 15 minutes.

Bjorn
