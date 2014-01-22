Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaAVEyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 23:54:31 -0500
Received: from ozlabs.org ([203.10.76.45]:49189 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbaAVEy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 23:54:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Cc: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] scripts/gcc-version.sh: handle CC="gcc -m32"
In-Reply-To: <871u07v9zu.fsf@rustcorp.com.au>
References: <87d2l5ji06.fsf@rustcorp.com.au> <52C6EF1C.9070809@suse.cz> <52C71EDA.6090706@suse.cz> <87k3e1x4ho.fsf@rustcorp.com.au> <52D7FBF7.2070508@suse.cz> <871u07v9zu.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 22 Jan 2014 15:09:11 +1030
Message-ID: <87eh40sk9c.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:
> Michal Marek <mmarek@suse.cz> writes:
>>> gcc: warning: ‘-mcpu=’ is deprecated; use ‘-mtune=’ or ‘-march=’ instead
>>> gcc: warning: ‘-mcpu=’ is deprecated; use ‘-mtune=’ or ‘-march=’ instead
>>> kernel/bounds.c:1:0: error: CPU you selected does not support x86-64 instruction set
>>>  /*
>>>  ^
>>> kernel/bounds.c:1:0: warning: -mregparm is ignored in 64-bit mode [enabled by default]
>>> make[1]: *** [kernel/bounds.s] Error 1
>>> make: *** [prepare0] Error 2

Sorry, ignore this report.

In case anyone else hits this: was resolved by installing more 32 bit headers
(Ubuntu's libc6-dev-i386 package, in this case).

Thanks,
Rusty.
