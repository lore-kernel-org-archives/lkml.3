Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab3DQAYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:24:19 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:42904 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3DQAYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:24:18 -0400
Date: Tue, 16 Apr 2013 19:24:13 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC 4/7] Docs: Add info on supported kernels to
 REPORTING-BUGS.
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <2c97a63f6fec91db91241981808d099ec60a4688.1366046390.git.sarah.a.sharp@linux.intel.com>
	(from sarah.a.sharp@linux.intel.com on Mon Apr 15 12:33:33 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1366158253.18069.109@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 12:33:33 PM, Sarah Sharp wrote:
> One of the most common frustrations maintainers have with bug  
> reporters
> is the email that starts with "I have a two year old kernel from an
> embedded vendor with some random drivers and fixes thrown in, and it's
> crashing".
> 
> Be specific about what kernel versions the upstream maintainers will  
> fix
> bugs in, and direct bug reporters to their Linux distribution or
> embedded vendor if the bug is in an unsupported kernel.

Back in 2006 I wrote a section of the BusyBox FAQ about this:

http://git.busybox.net/busybox/tree/docs/busybox.net/FAQ.html?id=95718b3091690f1293e3069da75d0d4be2665d0e#n359

(Alas, the current version of that page had a large project specific  
chunk dumped into the middle of it, but the text I linked to out of the  
repo is reasonably generic to just about any project. Feel free to lift  
anything that's useful. :)

Rob