Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab3G3VVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 17:21:07 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:44371 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044Ab3G3VVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 17:21:05 -0400
From: Nix <nix@esperi.org.uk>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        nick.cheng@areca.com.tw, stable@vger.kernel.org
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87fvuxdqes.fsf@spindle.srvr.nix> <51F708A4.9090207@interlog.com>
	<87ob9koogb.fsf@spindle.srvr.nix> <51F80294.50804@fastmail.fm>
Emacs: is that a Lisp interpreter in your editor, or are you just happy to see me?
Date: Tue, 30 Jul 2013 22:20:55 +0100
In-Reply-To: <51F80294.50804@fastmail.fm> (Bernd Schubert's message of "Tue,
	30 Jul 2013 20:14:44 +0200")
Message-ID: <877gg7n3rc.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: spindle 1245; Body=7 Fuz1=7 Fuz2=7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 Jul 2013, Bernd Schubert told this:

> On 07/30/2013 02:56 AM, Nix wrote:
>> On 30 Jul 2013, Douglas Gilbert outgrape:
>>
>>> Please supply the information that Martin Petersen asked
>>> for.
>>
>> Did it in private IRC (the advantage of working for the same division of
>> the same company!)
>>
>> I didn't realise the original fix was actually implemented to allow
>> Bernd, with a different Areca controller, to boot... obviously, in that
>> situation, reversion is wrong, since that would just replace one won't-
>> boot situation with another.
>
> Unless there is very simple fix the commit should reverted, imho. It
> would better then to remove write-same support from the md-layer.

I'm not using md on that machine, just LVM. Our suspicion is that ext4
is doing a WRITE SAME for some reason.

-- 
NULL && (void)
