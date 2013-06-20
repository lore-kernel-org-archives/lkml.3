Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab3FTHrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:47:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:59258 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab3FTHrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:47:24 -0400
Date: Thu, 20 Jun 2013 09:47:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: timer: looping issue, need reset variable
 'found'
In-Reply-To: <51C039A8.5000903@asianux.com>
Message-ID: <alpine.DEB.2.02.1306200944530.4013@ionos.tec.linutronix.de>
References: <51B4A408.4050909@asianux.com> <alpine.LFD.2.02.1306101501160.22970@ionos> <51C039A8.5000903@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Chen Gang wrote:
> On 06/10/2013 10:12 PM, Thomas Gleixner wrote:
> I think we can treat original implementation as for speed optimization,
> so our discussion is "whether this speed optimization has effect with
> correctness".

Then I recommend that you to sit down and analyze the correctness of
the code.

Come back when you have a proof of the code being wrong. And by proof
I mean factual proof not just handwaving theories.

Thanks,

	tglx

