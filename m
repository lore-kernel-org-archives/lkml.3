Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab3DANOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:14:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49401 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788Ab3DANOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:14:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>
Subject: Re: [PATCH 0/2] USB PM and PM QoS fixes (Re: gpf in pm_qos_remote_wakeup_show)
Date: Mon, 01 Apr 2013 15:22:09 +0200
Message-ID: <5523281.Sof23AT7pc@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+55aFwW7N-tVLg4NJBu3T_VUqCVHNi1MkF3cmvFq5ymn3ExRg@mail.gmail.com>
References: <512F8980.4040809@oracle.com> <1876128.a4gSDF7byc@vostro.rjw.lan> <CA+55aFwW7N-tVLg4NJBu3T_VUqCVHNi1MkF3cmvFq5ymn3ExRg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 31, 2013 08:29:20 PM Linus Torvalds wrote:
> On Sun, Mar 31, 2013 at 3:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > So, I have two patches (on top of the Linus' tree) that will follow shortly:
> 
> Should I take these directly as patches, or expect them to show up in
> a pull soon (ie do you have or expect to have other things pending)?

I'm going to send one more pull request with changes for 3.9 later this week
and I'll include these two.

Rafael

