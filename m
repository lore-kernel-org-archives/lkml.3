Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3LMDbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 22:31:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56610 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3LMDbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 22:31:12 -0500
Message-ID: <1386905449.4871.11.camel@marge.simpson.net>
Subject: Re: [PATCH 00/15] cleanups and optimizations
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        paulmck@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Date: Fri, 13 Dec 2013 04:30:49 +0100
In-Reply-To: <20131212140835.729222186@infradead.org>
References: <20131212140835.729222186@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:RLRsdwSzL3kJ7JPTOfuqWTp6huC3phdho4ZkqeUps2A
 1pj2y+KO6f0R9R4H/9A2cb6tIzlQvVEQgsij8IVW/roepgn2Kf
 +mmh/8gcP7qMNtnaEv5luj7EPEAZ9uyG4Be7xyAEejNcomZPK7
 SjHOfikkJXmTUb9NBST7SbIkUR7ctZF4+sBO4VOQmDK+TikDyy
 eIIuVWnf5vdevO48ooQlpDGdinMN3dpRCej2XcCeeltd5cj5zi
 9/H3BaLvO2ql84zXuJrOrJ6WCPyf8GV/9pLMKlvIjl+gNw2gRN
 V4ezIySGOG9XErfczUNFjI8DeFlt0QCzSdPXdxiFY7X0tA1oiG
 TAYcWc/i9BY1QTAMxrpwcnpBnHPNwpicZWDaQUc4Lhg6HHfxdM
 z8aovzJyEmPrg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-12 at 15:08 +0100, Peter Zijlstra wrote: 
> This series contains the preempt_enable_no_resched() cleanups that include
> spin_lock_bh() optimizations and local_clock() optimizations.

Those clock optimizations look particularly yummy.

-Mike

