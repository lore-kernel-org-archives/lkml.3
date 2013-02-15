Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957Ab3BOCPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 21:15:38 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:55083 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3BOCPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 21:15:36 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1302141804400.3330@eggly.anvils>
References: <20130212193901.GA18906@redhat.com> <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
 <20130213004059.GA14451@redhat.com> <alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
 <20130213041629.GA28622@redhat.com> <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
 <20130213193411.GA15928@redhat.com> <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
 <20130215011503.GA11914@redhat.com> <alpine.LNX.2.00.1302141804400.3330@eggly.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 14 Feb 2013 18:15:15 -0800
X-Google-Sender-Auth: xXgcLbskSX2H03RggWtDLIsjoKA
Message-ID: <CA+55aFyLDnmwy16V8TQRwJV2O51K-dmqBhuWi2ytRd4sYi8J+g@mail.gmail.com>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
To: Hugh Dickins <hughd@google.com>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 6:09 PM, Hugh Dickins <hughd@google.com> wrote:
>
> Which won't affect my case since I never enabled it.

Well, in theory, you may have the same bug Dave just made it easier to
trigger for himself with the forced config option.

In reality, your bug behavior differences were already big enough that
it sounded likely that they were two different things to start with..

              Linus
