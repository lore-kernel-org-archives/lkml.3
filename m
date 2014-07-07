Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaGGUTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:19:05 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:61063 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaGGUTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:19:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVgwJRj40p9FtnezoEmHLDYTJYQ8tDhZ_XyP7VOntFJF-Q@mail.gmail.com>
References: <CAPDOMVgwJRj40p9FtnezoEmHLDYTJYQ8tDhZ_XyP7VOntFJF-Q@mail.gmail.com>
Date: Tue, 8 Jul 2014 00:19:02 +0400
Message-ID: <CAMo8BfK42NXLXc_pfxQX+eR_tbH_cLcRHGhXUU_emKRmq80wbA@mail.gmail.com>
Subject: Re: Compiler Tests
From: Max Filippov <jcmvbkbc@gmail.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Tue, Jul 8, 2014 at 12:05 AM, Nick Krause <xerofoify@gmail.com> wrote:
> I am posting in this message which tests still are failing to l
> compile from this link,
> http://kisskb.ellerman.id.au/kisskb/branch/9/. Please note I didn't test
> rand configs. I have posting to the default kernel list due to not knowning
> what lists to post to. I can recompile any of these and sent the errors if
> needed.
> Cheers Nick

[...]

> xentsa - fails in defconfig

It's not the compilation that fails for xtensa, it's the linking step.
It fails due to
a number of bugs in currently released binutils versions. Fixes for
most of these
bugs are now in the binutils mainline, and in the buildroot, so building kernel
with the latest buildroot toolchain has greatly improved chances to succeed.

-- 
Thanks.
-- Max
