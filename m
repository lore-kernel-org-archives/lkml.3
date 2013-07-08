Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab3GHXIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 19:08:47 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:50464
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753392Ab3GHXIp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 19:08:45 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371Ic89bh1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Mon, 8 Jul 2013 16:08:41 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Landley <rob@landley.net>
CC: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] menuconfig: Allow j/k to move down/up the menu
References: <1373023979-20537-1-git-send-email-artagnon@gmail.com>
 <1373151605.27613.9@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1373151605.27613.9@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <478d866c-606e-42de-9779-6ae18d70e7f1@CO1EHSMHS014.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 06:00:05PM -0500, Rob Landley wrote:
> On 07/05/2013 06:32:59 AM, Ramkumar Ramachandra wrote:
> >Like in Vim.
> >
> >Cc: Michal Marek <mmarek@suse.cz>
> >Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> >---
> > Unsure why nobody has done this yet.
> 
> While you're at it, why don't you add the ws up and down bindings
> from World of Warcraft?
> 
> The reason nobody has done this yet is that vi predates the
> invention of cursor keys. They keyboards Bill Joy was using in the
> 1970's did not have standardized cursor keys, in large part because
> you can't cursor around on a teletype printer. Once people started
> using "glass tty" devices (vt100 and such) cursor keys got
> standardized within a few years. They were reasonably ubiquitous by
> the time the IBM PC showed up (the vic 20 and commodore 64 and such
> all had them; anything that displayed to a television instead of
> through a daisy wheel).
> 
> They also didn't have ALT or control keys. The vi modal interface is
> a legacy of not having any standardized keys on the keyboard except
> letters, numbers, and (for 8 bit machines) shift. (There's a song
> "double bucky" to the tune of "Rubber Ducky" that commemorates a
> particular bespoke keyboard design from MIT in the 1970's.) Even the
> punctuation was potluck for a while there, although they could copy
> manual typewriters and the IBM selectric and such for some of that.
> 
> And now you know _why_ Linux is over 20 years old and has never
> needed this.
Well, one advantage of these key bindings is, that you don't have to
move your hands away from the base line. And as vim user I find myself
using vim key sequences in all tools. I cannot even count how many
processes I accidentally killed because I tried to scroll using 'k' in
htop where it does 'kill'.

In a nutshell: I'm all for vim key bindings everywhere!

But on the other hand, I can see that it might lead straight to chaos when
everybody pushes his favorite key bindings.

	Sören


