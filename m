Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaI2UgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:36:09 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:52933 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970AbaI2UgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:36:07 -0400
Message-ID: <1412022964.6334.104.camel@x220>
Subject: Re: [PATCH] lib: rename TEST_MODULE to TEST_LKM
From: Paul Bolle <pebolle@tiscali.nl>
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Sep 2014 22:36:04 +0200
In-Reply-To: <CAD3Xx4K5hg-sZb5Ek=q=cgPt59+Y8wgAs1iEWOFx2EMcz3EZAg@mail.gmail.com>
References: <1411455508-11958-1-git-send-email-valentinrothberg@gmail.com>
	 <5421A4B4.1040604@infradead.org> <1411492210.30136.15.camel@nebuchadnezzar>
	 <5421A9D5.8020503@infradead.org> <1411496822.31476.1.camel@nebuchadnezzar>
	 <1412021904.6334.97.camel@x220>
	 <CAD3Xx4K5hg-sZb5Ek=q=cgPt59+Y8wgAs1iEWOFx2EMcz3EZAg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2014 20:36:04.0943 (UTC) FILETIME=[FDA535F0:01CFDC24]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-29 at 22:25 +0200, Valentin Rothberg wrote:
> On Mon, Sep 29, 2014 at 10:18 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > Maybe something like "TEST_MODULE_LOAD"?
> 
> It has been merged already, see [1]. Sorry, I did not check if you
> were in the CC to let you know.
> 
> [1] http://ozlabs.org/~akpm/mmotm/broken-out/lib-rename-test_module-to-test_lkm.patch

That didn't hit lkml, did it? Don't know whether mmotm is set in stone
nor whether Kees has strong feelings about the name of this feature. (I
suspect I'm wandering into bicycle shed territory here...).

> > If something like this gets applied a follow up patch to make the kbuild
> > system reject Kconfig symbols ending in _MODULE might be nice.

Will do. But you're free to beat me to it.

Thanks,


Paul Bolle

