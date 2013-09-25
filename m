Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3IYQ76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:59:58 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53857 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3IYQ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:59:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130925183632.08a0d073@rechenknecht2k7>
References: <20130830124622.5f81b7d4@rechenknecht2k7>
	<20130830154205.GA1411@kroah.com>
	<20130925183632.08a0d073@rechenknecht2k7>
Date: Wed, 25 Sep 2013 19:59:56 +0300
Message-ID: <CAJL_dMvTwh+NL3Qp6UWYgSQtLwH6utxckFqRuqZC=5qUXJeUTg@mail.gmail.com>
Subject: Re: [PATCH] add exFAT driver
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 7:36 PM, Benjamin Valentin
<benpicco@zedat.fu-berlin.de> wrote:
> Am Fri, 30 Aug 2013 08:42:05 -0700
> schrieb Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>
>> For staging drivers I need a maintainer that is going to take the time
>> to shephard it into the core kernel tree.  See other TODO files for
>> how that person is defined.  Are you going to be willing to do this?
>
> I can see what I can do.
>
> I've cleaned up the code a bit, especially where it would redefine
> kernel functions. [1] Should I submit the end result, one file per
> patch, or begin with the original code and submit patches on top of
> that?

For staging code:
1. It must pass compile.
2. you have an TODO file with things to do to clean it up to the
standard quality of the kernel.
