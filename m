Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaGTKz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 06:55:58 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33617 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaGTKz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 06:55:57 -0400
X-Auth-Info: qWhfkWYTWF5s3GCP9p+HCCqss1Wkaty1yJNQC128xOI=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ls -l  /proc/1/exe -> Permission denied
References: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se>
	<87lhrpayl4.fsf@igel.home>
	<OF152BAB0C.4FB2E7A9-ONC1257D1B.0031887F-C1257D1B.0031B248@transmode.se>
X-Yow: Sign my PETITION.
Date: Sun, 20 Jul 2014 12:55:53 +0200
In-Reply-To: <OF152BAB0C.4FB2E7A9-ONC1257D1B.0031887F-C1257D1B.0031B248@transmode.se>
	(Joakim Tjernlund's message of "Sun, 20 Jul 2014 11:02:48 +0200")
Message-ID: <87fvhwxps6.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joakim Tjernlund <joakim.tjernlund@transmode.se> writes:

> Andreas Schwab <schwab@linux-m68k.org> wrote on 2014/07/19 22:21:59:
>> 
>> Joakim Tjernlund <joakim.tjernlund@transmode.se> writes:
>> 
>> > Trying to real /proc/<pid>/exe I noticed I could not read links not 
>> > belonging to my user such as:
>> > jocke >  ls -l /proc/1/exe
>> >              ls: cannot read symbolic link /proc/1/exe: Permission 
> denied
>> >
>> > Is this expected?
>> 
>> Yes.  This information is considered private.
>
> I don't understand why though.

It would allow bypassing access restrictions.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
