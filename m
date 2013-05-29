Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966001Ab3E2TAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:00:09 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:38793 "HELO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965553Ab3E2S76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:59:58 -0400
MIME-Version: 1.0
In-Reply-To: <CACG0VPV3-x5Ncp+_hci8wVNYUeqAUZ0KFm0MAuHMntXzaL9Nqw@mail.gmail.com>
References: <CACG0VPV3-x5Ncp+_hci8wVNYUeqAUZ0KFm0MAuHMntXzaL9Nqw@mail.gmail.com>
Date: Wed, 29 May 2013 11:59:58 -0700
Message-ID: <CALnjE+p3vFkYBu=XioeDTEL1cyXh_379ix84Yoojj1eB11q57Q@mail.gmail.com>
Subject: Re: Network issue on 3.10 rcs, bisected
From: Pravin Shelar <pshelar@nicira.com>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 4:37 AM, Joao Correia
<joaomiguelcorreia@gmail.com> wrote:
> Hello list
>
> While trying the rc's for 3.10, i've stumbled upon a problem where
> networking does not work at all. Iptables will show packet counts going up,
> but nothing actually reaches the programs.
>
> I'm running fedora under hyper-v 3 (a windows 2012 host). Only tested ipv4
> traffic, and everything times out (ping, telnet to open ports) on both
> directions. The networking devices come up apparently ok - has static ip
> set, and dmesg shows no errors (although i don't have many debugging options
> enabled).
>
> I bisected this, and git blames commit
> ec5f061564238892005257c83565a0b58ec79295 (net: ill link between CSUM and SG
> features.). I can't revert it cleanly on current rc's.
>
Can you also send network features set on the device?
ethtool -k <dev>

Thanks,
Pravin.
> Please find the attached config used, as well as lshw output. Logs show no
> errors.
>
> I'm willing and able to test fixes.
>
> Thank you for your time,
> Joao Correia
> CIUBI
> Universidade da Beira Interior
> Portugal
>
>
>
