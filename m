Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab3HKBkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 21:40:40 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57452 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751447Ab3HKBkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 21:40:36 -0400
Date: Sat, 10 Aug 2013 21:40:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Josep Lladonosa <jlladono@gmail.com>
cc: Thomas Richter <richter@rus.uni-stuttgart.de>, <linux@brodo.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on
 E7110
In-Reply-To: <CAPBO7Tbi0mjPOs7migmvm9TUyezsMfxpFrGxZMPodd2hvbXY5A@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1308102139310.10834-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Aug 2013, Josep Lladonosa wrote:

> Hello,
> 
> Have you tried to wait for 5 minutes? It could also be related to it
> what happens to my kernel 3.11.0-rc4 (and rc3) and USB
> 
> I plug the drive. Only after 5 minutes of high-speed of USb bus, it mounts.

Your experience is not related to Thomas's problem.  It can be 
fixed by applying this patch:

	http://marc.info/?l=linux-usb&m=137523956310060&w=2

Alan Stern

