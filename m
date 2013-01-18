Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3AROVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:21:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55801 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3AROVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:21:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 09/76] ARC: Checksum/byteorder/swab routines
Date: Fri, 18 Jan 2013 14:21:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-10-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-10-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181421.09458.arnd@arndb.de>
X-Provags-ID: V02:K0:+yf6Dzp/vFodp6M/OyfWBEMbuhN6vpcAIb3WD90VbQX
 47dRlwMKEk+xgV05vB9Ky+MOcl9/BvWw+TTrnltW7aYtUpEYPw
 kSptVdODfX2vv3YKdyhBbnqwbSvR7Ay4pbOFHifpP6ahV1Qprf
 7SCwWEGkVLUgdCEy/myreFhdzIGVk/kFFRw9m2FwnjqWDmQVPS
 LODY3oQxy5svjtxdbhJ3WKvfWe/VGlI+MwgLCjkYavopsGnsTx
 O7a169ZEwo+eM3zsLNY66KvGdnozHmZE0fRwIrWRQW183M0Y9Q
 f11nGjqP6vQ6dqcvHFCPBsXNaKSfjCnkHzIdqg1UIfJfvYLmV/
 gFRFe+DiBAX755/xdN14=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> TBD: do_csum still needs to be written in asm

Do you actually expect a lot of improvement in do_csum?
I would hope that gcc can actually generate a pretty
good version of it, unless you have some 64-bit add-with-carry
instruction or something else that you could make use of.

> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
