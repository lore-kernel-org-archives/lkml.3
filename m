Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaLZMnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 07:43:11 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56187 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaLZMnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 07:43:08 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXPt=GM08PD8LOpCdxCYhNMrr-2MHxPyNRWPXqUjQXFrw@mail.gmail.com>
References: <CA+icZUXPt=GM08PD8LOpCdxCYhNMrr-2MHxPyNRWPXqUjQXFrw@mail.gmail.com>
Date: Fri, 26 Dec 2014 13:43:07 +0100
Message-ID: <CA+icZUVfiQ1+k2zD9HXMM40N8rwg6rEmYLdKfHGsGt3xvJu+4w@mail.gmail.com>
Subject: Re: deb-pkg: Cleaning of debian/*tmp files when running 'make (dist)clean'
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Michal Marek <mmarek@suse.cz>, Ben Hutchings <ben@decadent.org.uk>,
        maximilian attems <max@stro.at>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 1:02 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
[...]
>
> Any other make (PHONY) target I don't know?
>

I fell over "clean-dirs"...

scripts/package/Makefile:93:clean-dirs += $(objtree)/debian/

...but did not really understood how it works.
The main Makefile defines some clean-dirs PHONY#s.
I can only speculate, someone with more skillz in Makefile handling
should look at this.

Thanks.

- Sedat -
