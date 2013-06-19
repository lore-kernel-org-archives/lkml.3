Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab3FSTFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:05:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55570 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757458Ab3FSTFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:05:50 -0400
Message-ID: <1371668748.2038.40.camel@joe-AO722>
Subject: Re: [tip:x86/asm] x86/vdso: Convert use of typedef ctl_table to
 struct ctl_table
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org,
        tglx@linutronix.de, tip-bot for Joe Perches <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Date: Wed, 19 Jun 2013 12:05:48 -0700
In-Reply-To: <51C1FCA7.6050501@zytor.com>
References: <a756fa0060e8eea25e8c1863c2764e86c2823617.1371177118.git.joe@perches.com>
	 <tip-f07d91ede6f346cbe31bb814cefe2584940b96f3@git.kernel.org>
	 <51C1FCA7.6050501@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 13:47 -0500, H. Peter Anvin wrote:
> Shouldn't this actually remove the typedef?

Much later, yes.

The uses are ~50:50 for the typedef vs struct ctl_table.

It's used all over the tree and it likely won't be
removed for several months after Jiri lets it filter
through the various maintainers to pick up directly.

I'll resend the bits that haven't been picked up
in a few months along with the typedef removal.


