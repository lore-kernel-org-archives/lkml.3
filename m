Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070Ab3GSJHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:07:16 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:56917 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3GSJHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:07:14 -0400
MIME-Version: 1.0
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Fri, 19 Jul 2013 14:36:32 +0530
Message-ID: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com>
Subject: [QUERY] lguest64
To: LKML <linux-kernel@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried building lguest to play with it, but was disappointed to find
this in the Kconfig:

  depends on X86_32

Why is this [1]?  What is so hard about supporting 64-bit machines?  I
found a five-year old tree that claims to do lguest64 [2], but didn't
investigate further.

Thanks.

[1]: More importantly, who runs 32-bit kernels anymore?
[2]: http://git.et.redhat.com/?p=kernel-lguest-64.git;a=summary
