Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab3LDPhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:37:09 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48252 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526Ab3LDPhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:37:07 -0500
Date: Wed, 4 Dec 2013 16:37:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        kevin.b.smith@intel.com, hjl.tools@gmail.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86-64, build: Always pass in -mno-sse
Message-ID: <20131204153703.GA5627@gmail.com>
References: <tip-j21wzqv790q834n7yc6g80j1@git.kernel.org>
 <20131204085448.GA31778@gmail.com>
 <8798ec32-5add-4772-9c41-6f69401b16c9@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8798ec32-5add-4772-9c41-6f69401b16c9@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> I can regenerate the patch if you want.

No need, I think a separate cleanup patch might be better (in a 
non-urgent branch), because currently a number of other lines in 
arch/x86/Makefile are violating this kbuild convention as well.

Thanks,

	Ingo
