Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaBATH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 14:07:59 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:38159 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaBATH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 14:07:58 -0500
MIME-Version: 1.0
In-Reply-To: <52EC259F.4080206@linux.intel.com>
References: <20140131025453.B594B660CA3@gitolite.kernel.org>
	<20140131175009.GA27231@redhat.com>
	<52EBE62E.70102@linux.intel.com>
	<CA+55aFwcgGPb=5cTnkKpP4vH2kqCCvxGteZT58efHhg3aJjcfQ@mail.gmail.com>
	<52EC259F.4080206@linux.intel.com>
Date: Sat, 1 Feb 2014 11:07:57 -0800
X-Google-Sender-Auth: M76yZobiiHKVBftqysvFt1YTPCA
Message-ID: <CA+55aFyKS_C3Pd8aXuJaOiZR=xigesOoyBfmAhS+y5n68X3JfA@mail.gmail.com>
Subject: Re: x86, x32: Correct invalid use of user timespec in the kernel
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 2:37 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> Here is a patch for comments/review/opinions... it has only been
> compile-tested.

Looks sane to me from a superficial quick read-through.

             Linus
