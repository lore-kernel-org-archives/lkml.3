Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab3HJUFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 16:05:07 -0400
Received: from charon.rus.uni-stuttgart.de ([129.69.1.54]:42956 "EHLO
	charon.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754567Ab3HJUFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 16:05:06 -0400
Message-ID: <52069CED.5050003@rus.uni-stuttgart.de>
Date: Sat, 10 Aug 2013 22:05:01 +0200
From: Thomas Richter <richter@rus.uni-stuttgart.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Josep Lladonosa <jlladono@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on E7110
References: <52062353.9030800@rus.uni-stuttgart.de> <Pine.LNX.4.44L0.1308100801470.31571-100000@netrider.rowland.org> <CAPBO7Tbi0mjPOs7migmvm9TUyezsMfxpFrGxZMPodd2hvbXY5A@mail.gmail.com> <520699F2.7080808@rus.uni-stuttgart.de> <CAPBO7TYBWg-vyX3YocGZ94ALbiZC7E-1TWr5zndPob_xyPvqTQ@mail.gmail.com>
In-Reply-To: <CAPBO7TYBWg-vyX3YocGZ94ALbiZC7E-1TWr5zndPob_xyPvqTQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josep,

>
> Perhaps both cases are related, and if you waited after those 5
> minutes of resets, your pen would work fine...
> Have you checked your /var/log/messages after insertion of pen?
>
> My automount is under XFCE, not Gnome... ;)

Unclear. Messages I get seem to make sense. First, it detects the 
insertion, then after five seconds or so, it creates the device file. If 
I mount this, I get the problem.

So long,
	Thomas


