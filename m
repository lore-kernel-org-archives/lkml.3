Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab3IWBaB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:30:01 -0400
Received: from ozlabs.org ([203.10.76.45]:56369 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab3IWB35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:29:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Rob Landley <rob@landley.net>
Cc: torvalds@linux-foundation.org, "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why does test_bit() take a volatile addr?
In-Reply-To: <1379885847.1974.45@driftwood>
References: <87ioy11k8s.fsf@rustcorp.com.au> <1379885847.1974.45@driftwood>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 23 Sep 2013 10:43:14 +0930
Message-ID: <87mwn4xrv9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:
> On 09/15/2013 11:08:35 PM, Rusty Russell wrote:
>> Predates git, does anyone remember the rationale?
>
> Depends which git: http://landley.net/kdocs/fullhist/ :)

Not useful.  See Geert's more helpful response.

Cheers,
Rusty.
