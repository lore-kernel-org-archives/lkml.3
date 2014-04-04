Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaDDM60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:58:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48102 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbaDDM6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:58:23 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140404080006.GB6944@gmail.com>
References: <20140404064120.GB11877@gmail.com> <tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org> <20140404080006.GB6944@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method before the PCI reboot method
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 04 Apr 2014 05:37:42 -0700
To: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mjg59@srcf.ucam.org,
        aubrey.li@linux.intel.com, rostedt@goodmis.org, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Message-ID: <ce8e2a0c-c9be-4b74-af7c-8c3efe6769b8@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying anything at all after BIOS is meaningless as BIOS is terminal... it will either work or it will hang.  Triplefault is the same way.

On April 4, 2014 1:00:07 AM PDT, Ingo Molnar <mingo@kernel.org> wrote:
>
>* tip-bot for Ingo Molnar <tipbot@zytor.com> wrote:
>
>> Commit-ID:  d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3
>> Gitweb:    
>http://git.kernel.org/tip/d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3
>> Author:     Ingo Molnar <mingo@kernel.org>
>> AuthorDate: Fri, 4 Apr 2014 08:41:26 +0200
>> Committer:  Ingo Molnar <mingo@kernel.org>
>> CommitDate: Fri, 4 Apr 2014 08:48:03 +0200
>> 
>> [PATCH] x86: Try the BIOS reboot method before the PCI reboot method
>
>So, JFYI, I have put this into x86/reboot to get it tested, but it's 
>not queued up for upstream yet until there's concensus.
>
>(Steve testing it wouldn't hurt either.)
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
