Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaAUTDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:03:17 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:38979 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaAUTDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:03:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140121172405.GF27111@lee--X1>
References: <20140121172405.GF27111@lee--X1>
Date: Tue, 21 Jan 2014 11:03:14 -0800
X-Google-Sender-Auth: cdEORVQvqiXfqjpynQuTfGFoM_Q
Message-ID: <CA+55aFx+1W-0Eae7EcRh-AksfVKcOVBV3dWE+=DVGPDgaNCusQ@mail.gmail.com>
Subject: Re: [GIT PULL] MFD pull-request for v3.14
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 9:24 AM, Lee Jones <lee.jones@linaro.org> wrote:
>
> Please find the following v3.14 pull-request for the MFD Subsystem.

Hmm. The tag is signed, but you have a marked lack of signatures on
your key. Would you mind trying to correct that?

I've pulled, since hopefully linaro.org is well-maintained and you
have a lot of existing commits, but in general I dislike pulling
things from new people with badly connected gpg signatures, and I
think this is the first time I've pulled from you directly..

                   Linus
