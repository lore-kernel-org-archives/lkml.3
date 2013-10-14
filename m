Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab3JNPbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:31:33 -0400
Received: from smtpout4.mclink.it ([195.110.128.205]:61633 "EHLO
	smtpout4.mclink.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab3JNPaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:30:08 -0400
X-Greylist: delayed 1187 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Oct 2013 11:30:08 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgIFACcIXFJNK3Ai/2dsb2JhbABZgwfEHRZ0giUBAQQBOj8FCwEKISUPSIgZCr4Mj2+DCYEEA5gEAZICgyY6
Date: Mon, 14 Oct 2013 17:10:17 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: bp@alien8.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: fmc: BUG: scheduling while atomic: swapper/0/1/0x00000002
Message-ID: <20131014151017.GA13363@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20131014123406.GG4009@pd.tnic>
References: <20131014123406.GG4009@pd.tnic> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> I'm getting the following with randconfig testing in kvm, config is
> .attached.

I acknowledge this is a bug of mine, and your .config shows your are
testing v3.11.

I posted the fix on Jul 16th 2013, and it is now in master as
v3.11-rc2-11-g783c2fb.  However it is not an ancestor of v3.11, which
still has the bug.  "git tag --contains 783c2fb" reports v3.12-rc1 as
the first "official" kernel with the fix,

Thank you for your feedback, anyways.
/alessandro
