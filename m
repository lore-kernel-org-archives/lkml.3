Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaGBMaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:30:08 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:62977 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaGBMaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:30:06 -0400
Date: Wed, 2 Jul 2014 08:30:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, akpm@linux-foundation.org,
        andi@firstfloor.org, paulmck@linux.vnet.ibm.com, pavel@ucw.cz,
        jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: kGraft to -next [was: 00/21 kGraft]
Message-ID: <20140702123002.GA20071@mtj.dyndns.org>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz>
 <53B3F556.7050002@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B3F556.7050002@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 02, 2014 at 02:04:38PM +0200, Jiri Slaby wrote:
> On 06/25/2014 01:05 PM, Jiri Slaby wrote:
...
> > https://git.kernel.org/cgit/linux/kernel/git/jirislaby/kgraft.git/log/?h=kgraft
> 
> Stephen,
> 
> may I ask you to add the kGraft tree to -next?
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jirislaby/kgraft.git#kgraft

Do we have consensus on the approach?  I personally really don't like
the fact that it's adding another aspect to kthread management which
is difficult to get right and nearly impossible to verify
automatically.

IIUC, there are three similar solutions.  What are the pros and cons
of each?  Can we combine the different approaches?

Thanks.

-- 
tejun
