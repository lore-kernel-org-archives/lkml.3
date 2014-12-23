Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbaLWSpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 13:45:23 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:49815 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaLWSpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 13:45:22 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 23 Dec 2014 10:45:00 -0800
Message-ID: <CALCETrUkxvJZnkZ9cqCvMY+Y4_Kq6nPk4R+qx9f0p8WQQ=WRKw@mail.gmail.com>
Subject: Fixing the MPX prctl ABI?
To: Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it too late to move the MPX controls to arch_prctl?  If so, can we
at least fail the prctl with -EINVAL if any of the arguments are
nonzero?

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
