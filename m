Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3DKTUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:20:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab3DKTUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:20:23 -0400
Message-ID: <51670CF4.9050700@suse.cz>
Date: Thu, 11 Apr 2013 21:20:20 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowell@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/3] convert headers_install.pl to headers_install.sh
References: <1365697510.18069.78@driftwood>
In-Reply-To: <1365697510.18069.78@driftwood>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 11.4.2013 18:25, Rob Landley napsal(a):
> On 04/09/2013 05:52:32 AM, Michal Marek wrote:
>> I forgot to do it right after rc1, but I took the patch from the mm tree
>> now. I also added Sam's Ack from the earlier submission.
> 
> Yay!
> 
> Is this for 3.10?

Yes. The kbuild, kconfig, misc and trivial branches of kbuild.git
contain changes for the next merge window (next -rc1). The rc-fixes
branch is for the current rc phase.

Michal

