Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab3B0UXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 15:23:21 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:58822 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab3B0UXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 15:23:19 -0500
MIME-Version: 1.0
In-Reply-To: <20130227201503.GF14253@thunk.org>
References: <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com>
	<20130227172256.GA236@x4>
	<7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
	<20130227174553.GA224@x4>
	<CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
	<20130227184912.GA19624@thunk.org>
	<20130227185625.GA224@x4>
	<20130227191923.GA1121@redhat.com>
	<20130227192907.GB14253@thunk.org>
	<20130227201217.GD14253@thunk.org>
	<20130227201503.GF14253@thunk.org>
Date: Wed, 27 Feb 2013 12:23:18 -0800
X-Google-Sender-Auth: CF2TFDe81h-d2PwVRIlSjffY8Jo
Message-ID: <CA+55aFx+mHr080Wzfo8s8cb4qAO74x0r8iDFE90CziybFSTgQA@mail.gmail.com>
Subject: Re: [GIT PULL URGENT] ext4 regression fix for 3.9
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "gnehzuil.liu" <gnehzuil.liu@gmail.com>,
        Zheng Liu <wenqing.lz@taobao.com>, Borislav Petkov <bp@alien8.de>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 12:15 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Feb 27, 2013 at 03:12:17PM -0500, Linus Torvalds wrote:
>> The following changes since commit 304e220f0879198b1f5309ad6f0be862b4009491:
>
> Obviously, this wasn't from Linus.  I screwed up on sending the pull
> request.  Sigh...

That looked really odd in my inbox for a while ;)

          Linus "the *real* one" Torvalds
