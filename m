Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbaGNQC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:02:29 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35494 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbaGNQCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:02:22 -0400
Date: Mon, 14 Jul 2014 09:02:18 -0700
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xillybus: place 'else' on same line as '}'
Message-ID: <20140714160218.GA18975@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Eli Billauer <eli.billauer@gmail.com>, linux-kernel@vger.kernel.org
References: <1405307220-15946-1-git-send-email-jmmahler@gmail.com>
 <53C37B67.7000203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C37B67.7000203@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eli,

On Mon, Jul 14, 2014 at 09:40:39AM +0300, Eli Billauer wrote:
> Hi,
> 
> Thanks for this.
> 
> And since I looked at the part in Codingstyle that deals with if-else, I
> found another few mistakes regarding braces around a single statement. The
> rules say, it turns out, that if one of the clauses in an if-else is longer
> than one statement, both clauses should be wrapped with braces. This rule is
> broken in lines 162, 536 and 613 of the same file.
> 

I just looked through CodingStyle, and you are right.  If braces are
used on one branch they should be used on all branches.

Interestingly, checkpatch.pl doesn't warn about these.

> ...

Cheers,
-- 
Jeremiah Mahler
jmmahler@gmail.com
http://github.com/jmahler
