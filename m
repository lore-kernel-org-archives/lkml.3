Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968073Ab3DSKfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:35:06 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:64241 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967984Ab3DSKfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:35:04 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 19 Apr 2013 12:35:01 +0200
Message-ID: <CA+icZUXSbzxYjC2JWdso-OPVjjaoFkFX-t9f8CqJdVuPeE7vJw@mail.gmail.com>
Subject: [Q] Diff of two successive -next releases?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to do a diff between a problematic next-yyyymmdd and
next-[yyyymmdd+1].
How can I do this easily?

My old style was to checkout a specific Linux-Next release and then
create a diff against the latest -rcX (of mainline).
So, I have two diffs and try to compare them.

Thanks in advance.

Regards,
- Sedat -
