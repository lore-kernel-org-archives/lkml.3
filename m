Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3JNH5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 03:57:05 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:56038 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3JNH5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 03:57:03 -0400
Message-ID: <525BA3C2.4090407@synopsys.com>
Date: Mon, 14 Oct 2013 13:26:50 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: ARC fixes backport for stable 3.11
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.243]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Can you please apply the following mainline commits to your queue for next 3.11
stable, in that order.

7efd0da2d173 ARC: Fix __udelay calculation
c11eb222fd7d ARC: Handle zero-overhead-loop in unaligned access handler
0752adfda15f ARC: Fix 32-bit wrap around in access_ok()
6c00350b573c ARC: Workaround spinlock livelock in SMP SystemC simulation
10469350e345 ARC: Fix signal frame management for SA_SIGINFO
5b24282846c0 ARC: Ignore ptrace SETREGSET request for synthetic register "stop_pc"

Thx,
-Vineet
