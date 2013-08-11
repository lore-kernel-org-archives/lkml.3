Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab3HKGAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 02:00:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3HKGAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 02:00:36 -0400
Message-ID: <1376200711.15334.3.camel@marge.simpson.net>
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
From: Mike Galbraith <bitbucket@online.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org
Date: Sun, 11 Aug 2013 07:58:31 +0200
In-Reply-To: <f6227e5d-597b-4818-876a-3a21893cdd93@email.android.com>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
	 <5205C4BB.6020003@zytor.com> <1376114128.5332.17.camel@marge.simpson.net>
	 <5206659F.9070705@zytor.com> <1376194657.7006.11.camel@marge.simpson.net>
	 <520712AE.6060904@zytor.com> <1376195819.7006.18.camel@marge.simpson.net>
	 <f6227e5d-597b-4818-876a-3a21893cdd93@email.android.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:pAB7wEMNqt29n89+FtPdbXQq35MQ5IVhe3giL6Wak1C
 rWzimPNoIsIsnuM9B7YsoYj1rdIW1yz4EvYq5H/1Uby309gK5H
 DL1gE7F1ALHhorryE4SbaeU5ka54NcpOv7DDM/q/wpS6xfympN
 Nru3aucfZgwDDrFJGukn8PmL8EQWa6Eb6oGDBfh+4BYIX/VX56
 llI57vONhoAN3Z88dxyXWHy+El/e7CZhb8ul6YiSBLOp7B2y3M
 0UnhF/3Bzg0cxQJX7tF54MAUnN8ohP7WdlMBZ1hPhxeoAktyk6
 08gPsKNd9fa1XiSIuzECz+k5a6oiPIflWqFUWHcAsQOKh0gbPA
 Ic3dkW4JtN394MUuuxQiz35TaThAwnpx7u/JAoLQF+rEQWQz+0
 w/EQG8ctjoydA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-10 at 21:57 -0700, H. Peter Anvin wrote: 
> That sounds like an issue with specific preemption policies.

Actually, voluntary/nopreempt delta for _these_ loads was nil.

-Mike


