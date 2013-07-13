Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab3GMIRf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 04:17:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40929 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757848Ab3GMIRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 04:17:33 -0400
Date: Sat, 13 Jul 2013 10:17:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alexandru Juncu <alexj@rosedu.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Script for isolating maintainer email.
Message-ID: <20130713081711.GA5311@pd.tnic>
References: <1373701241-6499-1-git-send-email-alexj@rosedu.org>
 <20130713080153.GA5502@pd.tnic>
 <CAPhGq=b6FRJnjd+H_cxLLbs_cWR=p6WPdJtocV+je4=cCeRUmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhGq=b6FRJnjd+H_cxLLbs_cWR=p6WPdJtocV+je4=cCeRUmw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 11:05:04AM +0300, Alexandru Juncu wrote:
> Nothing wrong at all. It's just that, to my shame, I don't know Perl.

Now would be the right time to get your feet wet :-)

>From quickly skimming over it, it is almost ready:

./scripts/get_maintainer.pl --email --norolestats <patch>

gives you already the email addresses. What it would need is simply
adjusting the output to what --cc-cmd expects.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
