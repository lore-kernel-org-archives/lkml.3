Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaKCTyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:54:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:55195 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbaKCTyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:54:16 -0500
Date: Mon, 3 Nov 2014 20:54:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Shuah Khan <shuahkh@osg.samsung.com>
cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: rt-tester - move under selftests
In-Reply-To: <5446BDC6.4040502@osg.samsung.com>
Message-ID: <alpine.DEB.2.11.1411032052560.5308@nanos>
References: <5446BDC6.4040502@osg.samsung.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, Shuah Khan wrote:
> Andrew/Ingo/Thomas,
> 
> You are all on the signed-off list for rt-tester. I have been poking
> around the source tree looking for existing test and came across rt-tester.
> 
> What are your thoughts on rt-tester suitability to reside under
> tools/testing/selftest and becoming part of kselftest target?
> Would you like see it moved under the kselftest umbrella?

Sure you can move it, but it is broken and needs a complete
rewrite. So the proper solution is to remove it. I kept it there as a
reminder to fix it, but obviously I never managed to do so.

Thanks,

	tglx
