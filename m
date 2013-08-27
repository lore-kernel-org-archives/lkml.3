Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3H0Rl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 13:41:59 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55007 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab3H0Rl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 13:41:58 -0400
Date: Tue, 27 Aug 2013 19:41:56 +0200
From: Andreas Mohr <andi@lisas.de>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: weird keyboard issue (ps/2 port?) 3.9.x/3.10.x?
Message-ID: <20130827174156.GA19152@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521AED72.8050105@xs4all.nl>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> What could this be?
> Is it really a software issue?
> If so: how could I help fix this?

Perhaps watching the output of some input event tools could help
gather some clues to eventually get it nailed down?

Some candidates:

evtest - utility to monitor Linux input device events
input-utils - utilities for the input layer of the Linux kernel
xinput - Runtime configuration and test of XInput devices


And what do /proc/interrupts counts say? Does PS/2 (i8042) generate events?

while :; do clear; cat /proc/interrupts; sleep 1; done


HTH [shot in the dark],

Andreas Mohr
