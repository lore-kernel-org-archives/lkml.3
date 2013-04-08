Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135Ab3DHPcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:32:14 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:54179 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964999Ab3DHPcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:32:11 -0400
Message-ID: <1365435129.1830.115.camel@x61.thuisdomein>
Subject: Re: [PATCH] locking: remove three unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 17:32:09 +0200
In-Reply-To: <1365435015.1830.113.camel@x61.thuisdomein>
References: <1365428154.1830.99.camel@x61.thuisdomein>
	 <20130408151609.GA13640@gmail.com>
	 <1365435015.1830.113.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2013 15:32:10.0298 (UTC) FILETIME=[3C4BF1A0:01CE346E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 17:30 +0200, Paul Bolle wrote:
> Would you have any idea why this problem wasn't noticed in 16 (!)
> releases? Fedora 17, which I did this patch on, has Kconfig symbolk
> PREEMPT not set. Is it perhaps commit to not enable that option?

s/commit/common/ (and, obviously, s/symbolk/symbol/).


Paul Bolle

