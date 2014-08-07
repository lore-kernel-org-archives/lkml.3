Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbaHGO0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:26:32 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:54106 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaHGO0a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:26:30 -0400
From: Paul Moore <paul@paul-moore.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-security-module@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sel_netif_init: 'err' is used uninitialized (was: Re: selinux: reduce the number of calls to synchronize_net() when flushing caches)
Date: Thu, 07 Aug 2014 10:26:14 -0400
Message-ID: <5750080.46d2jsPKXX@sifl>
User-Agent: KMail/4.13.3 (Linux/3.15.7-gentoo; KDE/4.13.3; x86_64; ; )
In-Reply-To: <CAMuHMdV4VpaH1nHYO5hr66Xib5o_Pib863JzGRtg2kYcjMp2TQ@mail.gmail.com>
References: <CAMuHMdV4VpaH1nHYO5hr66Xib5o_Pib863JzGRtg2kYcjMp2TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 07, 2014 12:31:15 PM Geert Uytterhoeven wrote:
> 
> security/selinux/netif.c: In function ‘sel_netif_init’:
> /scratch/geert/linux/linux-m68k/security/selinux/netif.c:285: warning:
> ‘err’ is used uninitialized in this function
> 
> Should it just return 0, like before?
> Or should it return the return value of register_netdevice_notifier()
> instead, which also returns an error code? Or is that failure non-critical?

Hi,

I posted a fix for this two days ago to the SELinux list (see below).  As soon 
as -rc1 is released and linux-next is back in business I'll be pushing the 
patch to the SELinux #next branch.

 * http://marc.info/?l=selinux&m=140727033030054&w=2

-- 
paul moore
www.paul-moore.com

