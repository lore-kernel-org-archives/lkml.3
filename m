Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaKXAZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 19:25:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbaKXAZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 19:25:30 -0500
Date: Sun, 23 Nov 2014 19:25:21 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.18-rc6
Message-ID: <20141124002521.GA25241@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFx7PYp=a2FnpnvYy1jDHsvLsJDpO88KycPgEa3gmJwG7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx7PYp=a2FnpnvYy1jDHsvLsJDpO88KycPgEa3gmJwG7A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 04:08:21PM -0800, Linus Torvalds wrote:

 > Really not a whole lot of code changed, and if it wasn't for the
 > pending trouble from DaveJ, I'd probably be perfectly happy. Let's see
 > how that all unfolds, but in the meantime, the more testing this can
 > get, the better.

FYI, I gave 3.17 + perf fixes ~36 hours of runtime before calling it
good on Friday. Since then I've started a bisect, and I'm about 3 builds
deep on that, with 9-10 to go. 2 of the bad builds took the better part
of a day to hit, with the third happening in just an hour.
Hopefully I get more of the latter kind, and we can wrap this up this
week, though thanksgiving may upset things.

	Dave

