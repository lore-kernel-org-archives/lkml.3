Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3DAD3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 23:29:24 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:48447 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3DAD3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 23:29:21 -0400
MIME-Version: 1.0
In-Reply-To: <1876128.a4gSDF7byc@vostro.rjw.lan>
References: <512F8980.4040809@oracle.com>
	<51576A0C.5030907@oracle.com>
	<2829731.BFs3ri3Eud@vostro.rjw.lan>
	<1876128.a4gSDF7byc@vostro.rjw.lan>
Date: Sun, 31 Mar 2013 20:29:20 -0700
X-Google-Sender-Auth: KfGAcPyxS_lk-vJQFHnmJxGmVIo
Message-ID: <CA+55aFwW7N-tVLg4NJBu3T_VUqCVHNi1MkF3cmvFq5ymn3ExRg@mail.gmail.com>
Subject: Re: [PATCH 0/2] USB PM and PM QoS fixes (Re: gpf in pm_qos_remote_wakeup_show)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 31, 2013 at 3:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> So, I have two patches (on top of the Linus' tree) that will follow shortly:

Should I take these directly as patches, or expect them to show up in
a pull soon (ie do you have or expect to have other things pending)?

                    Linus
