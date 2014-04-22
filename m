Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaDVETs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 00:19:48 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:56469 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaDVETo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 00:19:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140421165050.GB8874@tassilo.jf.intel.com>
References: <1397795756-23283-1-git-send-email-andi@firstfloor.org>
	<CAKohpond9DbNqWHLi9ZdL0BJRwZjeDZcar7KYuC2kAvWZp96-Q@mail.gmail.com>
	<20140421165050.GB8874@tassilo.jf.intel.com>
Date: Tue, 22 Apr 2014 09:49:44 +0530
Message-ID: <CAKohpo=jqjDKWjAyJ-d0an_nv7Fpg-JWtg0Mm6tWGhH20s5Gvw@mail.gmail.com>
Subject: Re: [PATCH] Kbuild, lto: Avoid reported warning with strtoul
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, mmarek@suse.cz,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 April 2014 22:20, Andi Kleen <ak@linux.intel.com> wrote:
> Hmm that's odd. I guess could assign it to a dummy variable

That produces this:

scripts/mod/modpost.c: In function ‘remove_dot’:
scripts/mod/modpost.c:1708:16: warning: variable ‘ignore’ set but not
used [-Wunused-but-set-variable]

> or use viro's variant.

It looks fine but can't test if works exactly the same way as current
implementation.
