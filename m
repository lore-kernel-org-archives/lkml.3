Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaDCWCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:02:19 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:57807 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaDCWCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:02:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140403192021.GB32323@thunk.org>
References: <20140403175744.GE585@rampage>
	<533DA4DE.40408@archlinux.org>
	<20140403191617.GB2472@mtj.dyndns.org>
	<20140403192021.GB32323@thunk.org>
Date: Thu, 3 Apr 2014 18:02:18 -0400
Message-ID: <CAPEhTTFO08dZu8_P+eeUgOXoMkefQtWKyBmgj4cA8aq47-k=Pw@mail.gmail.com>
Subject: Re: Initramfs FSID altered in 3.14
From: Alexandre Demers <alexandre.f.demers@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Tejun Heo <tj@kernel.org>,
        =?ISO-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
        Dave Reisner <d@falconindy.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, P@draigbrady.com,
        Alexandre Demers <alexandre.f.demers@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll be testing it later tonight. It was either that or I would have
been completing my Qemu image. ;)

Stay tuned.

Alexandre

On Thu, Apr 3, 2014 at 3:20 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> I agree with Tejun that we should fix it up, and not force
> distributions to have to send out emergency releases of various
> userspace utilities --- especially since the fix is so simple.
>
>                                                  - Ted
