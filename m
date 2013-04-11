Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161373Ab3DKIgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:36:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab3DKIgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:36:47 -0400
Date: Thu, 11 Apr 2013 10:37:34 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/4] cputime: remove scaling
Message-ID: <20130411083734.GC1380@redhat.com>
References: <1364489605-5443-1-git-send-email-sgruszka@redhat.com>
 <1364489605-5443-5-git-send-email-sgruszka@redhat.com>
 <20130410120228.GC8083@gmail.com>
 <11f12774-5353-4380-82d0-e22707e11729@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11f12774-5353-4380-82d0-e22707e11729@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 07:29:21AM -0700, H. Peter Anvin wrote:
> I have a patch that does scaling by multiply for 64-bit architectures.  I probably should clean it up and send it in.  I need to see if it fixes this problem.
Interesting. Could you attach draft patch, so I could look at it ?

Stanislaw
