Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaAUSAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:00:14 -0500
Received: from mout.gmx.net ([212.227.17.20]:55267 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029AbaAUSAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:00:10 -0500
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT] Security subsystem changes for 3.14
Date: Tue, 21 Jan 2014 19:03:25 +0100
User-Agent: KMail/1.13.7 (Linux/3.12.6+; KDE/4.10.5; x86_64; ; )
Cc: James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LRH.2.02.1401210007390.27813@tundra.namei.org> <CA+55aFzAHNybM9bqb1gxAeOw-+z8=kSQvgwMDoUL3kXVfhcn8w@mail.gmail.com>
In-Reply-To: <CA+55aFzAHNybM9bqb1gxAeOw-+z8=kSQvgwMDoUL3kXVfhcn8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201401211903.25707.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:8UYtOQX2/eK9Iy6llDI/7OD5XVAR5ShUkQiqMFGITAPKswxt6Ql
 S4ZfwsqnUZ2ulerpVOjENIq9j/h2jcRsomQCTv+wDd4gXBoYAytYB0GoBzuW1zzOZG6HZD6
 SkwPsCdfSorLmX0NHARsxqPiPqPFRiYjuPoA2IODh0noRqxs/Wk8opxU6xEtdy5tm4Doaax
 NnuxwDi54XhlxioPYsgjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 21. Januar 2014, 18:15:01 schrieb Linus Torvalds:
> is that this is a callback for acpi_walk_namespace(), and returning a
> failure status means that the walk will be interrupted.
> 
> So you actually want to return AE_OK if the acpi_get_name() call
> fails, because that just skips the failing node. Returning failure
> will skip *all* the nodes.


Thanks Linus for pointing this out - and sorry, my bad.

Peter
