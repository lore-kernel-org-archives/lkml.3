Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbaDVUsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:48:35 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:52780 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143AbaDVUsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:48:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1404221303060.6220@eggly.anvils>
References: <20140422180308.GA19038@redhat.com>
	<CA+55aFxjADAB80AV6qK-b4QPzP7fgog_EyH-7dSpWVgzpZmL8Q@mail.gmail.com>
	<alpine.LSU.2.11.1404221303060.6220@eggly.anvils>
Date: Tue, 22 Apr 2014 13:48:32 -0700
X-Google-Sender-Auth: MU6NPYSBwhThNzaJh4lnNxC5a1U
Message-ID: <CA+55aFxs1eF7Wod0J_OUE+JRcfzZ99MEXhdtp8FjvxQKKUGZKw@mail.gmail.com>
Subject: Re: 3.15rc2 hanging processes on exit.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 1:17 PM, Hugh Dickins <hughd@google.com> wrote:
>
> One nit: we're inconsistent, and shall never move VM_READ,VM_WRITE bits,
> but it would set a better example to declare "vm_flags_t vm_flags"
> in your patch below, instead of "unsigned vm_flags".

Ack. Will do. And I'll mark it for stable, since I agree that this
does not look like it would be a new case.

             Linus
