Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaHFGex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 02:34:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45104 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbaHFGev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 02:34:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>
	<20140806144643.45e5dab8@canb.auug.org.au>
	<87lhr2tcyx.fsf@x220.int.ebiederm.org>
	<20140806160608.218b6944@canb.auug.org.au>
Date: Tue, 05 Aug 2014 23:30:59 -0700
In-Reply-To: <20140806160608.218b6944@canb.auug.org.au> (Stephen Rothwell's
	message of "Wed, 6 Aug 2014 16:06:08 +1000")
Message-ID: <877g2mt9i4.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX196BAo3D7RNUi+9hILAu5MY8sSaRs74olg=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0683]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
>> As for missing cool tags shrug.  The people looking at my code didn't
>> feel like saying the magic words so I didn't include cool tags.
>
> Maybe you should push them ... these tags are not just "cool", they
> give less involved people some indications of what has happened in the
> life of a patch.

Etiquette is a good idea where it helps things flow smoothly.  Other
times like this standing on etiquette would have resulted in trivial
fixes for long standing issues not going anywhere.

Althogh I will keep it in mind in the future.

>> Which is a my long winded way of say it sounds like you are accusing me
>> of being irresponsible, and my way of saying that I have tested and
>
> I did not mean to accuse, there are reasons (as you have pointed out)
> that things get added late, or rewritten.

I really try to avoid those reasons but I missed it this round and the
buildbot did not manage to find the comibination with a build error
until the code hit linux-next :(

Eric

