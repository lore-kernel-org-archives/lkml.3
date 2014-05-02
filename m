Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaEBVSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 17:18:46 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:57735 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaEBVSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 17:18:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140502210813.GB32527@tucsk.piliscsaba.szeredi.hu>
References: <20140429191015.GK18016@ZenIV.linux.org.uk>
	<20140429211851.GA32204@dastard>
	<20140429214842.GL18016@ZenIV.linux.org.uk>
	<CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
	<20140429232013.GM18016@ZenIV.linux.org.uk>
	<20140430023142.GN18016@ZenIV.linux.org.uk>
	<CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
	<20140430091515.GB3113@tucsk.piliscsaba.szeredi.hu>
	<20140502055127.GH18016@ZenIV.linux.org.uk>
	<CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
	<20140502210813.GB32527@tucsk.piliscsaba.szeredi.hu>
Date: Fri, 2 May 2014 14:18:43 -0700
X-Google-Sender-Auth: H4PogjXo8hhARcnOwheeBoVUFRk
Message-ID: <CA+55aFzbtGwxTf_d97pSLc4hAciErGDdkOSzLkpt_hP-UmLPWg@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 2:08 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> There's more of the "delete from shrink list not owned by us" in select parent.
> Proposed patch appended.

Ahh. Clearly this needs more work before I pull.

             Linus
