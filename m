Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaHGBH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:07:28 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:37797 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbaHGBH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:07:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
        ian.molton@codethink.co.uk, Al Viro <viro@ZenIV.linux.org.uk>
References: <1406655593-12626-1-git-send-email-rob.jones@codethink.co.uk>
	<20140806160259.GR18016@ZenIV.linux.org.uk>
	<53E254F1.30605@codethink.co.uk>
	<20140806195312.GS18016@ZenIV.linux.org.uk>
Date: Wed, 06 Aug 2014 18:03:32 -0700
In-Reply-To: <20140806195312.GS18016@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 6 Aug 2014 20:53:12 +0100")
Message-ID: <87d2cdp0uz.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/CKQm/qjwXPAmLW9kEkhPaXbod7G+ueqM=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0677]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rob Jones <rob.jones@codethink.co.uk>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] seq_file: Allow private data to be supplied on seq_open
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Wed, Aug 06, 2014 at 05:16:49PM +0100, Rob Jones wrote:
>
>> I'm not quite sure I understand your meaning when you say "via seq_open"
>> though, that function call format needs to stay the same or lots of
>> code will break, so I can't just add the third parameter on the end.
>> (C++ does have *some* advantages!) Can you clarify, please?
>
> seq_open_private() can be implemented as call of seq_open() +
> assignment...

This is why I object to the name seq_open_priv() for the new code.
seq_open_private() is already implemented and base on seq_open().

And the names are close enough together it is confusing :(

Eric
