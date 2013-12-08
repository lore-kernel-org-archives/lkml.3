Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3LHJcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 04:32:53 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:39850 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759154Ab3LHJ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 04:28:32 -0500
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Dec 2013 04:28:32 EST
Date: Sun, 8 Dec 2013 10:19:31 +0100 (CET)
From: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
To: Martin Quinson <martin.quinson@loria.fr>
Cc: Christoph Lameter <cl@linux.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Message-ID: <1587122162.1690.1386494371840.JavaMail.zimbra@linbit.com>
In-Reply-To: <20131206081816.GQ9578@alphonse.loria.fr>
References: <20131203233232.928771708@linux.com> <20131203233250.717784556@linux.com> <1386115809.2166.126.camel@dabdike.int.hansenpartnership.com> <alpine.DEB.2.02.1312051244540.26098@gentwo.org> <00000142c48e1f2a-fd398f0b-8726-4cec-a939-2c3a823bff39-000000@email.amazonses.com> <20131206081816.GQ9578@alphonse.loria.fr>
Subject: Re: quilt 0.60 does not include CCed email without name
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [85.127.247.122]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF25 (Linux)/8.0.5_GA_5839)
Thread-Topic: quilt 0.60 does not include CCed email without name
Thread-Index: V/Qvty8jVq/wi/oH9Ybi6s3LNgRG5w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin,

> [...] bug seems to be caused by:
> http://git.savannah.gnu.org/cgit/quilt.git/commit/?id=02f15444278eb3a854acae0192124153e0c6d9d4
> 
> I think that the last lines should be changed as follows (and same for
> the one before):
> - -e 's/^\('"$*"'\):\(.*<.*@.*>\)/Recipient-Cc:\2/Ip' \
> + -e 's/^\('"$*"'\):\(.*@.*\)/Recipient-Cc:\2/Ip' \

or something similar like .\+@.\+ for the email address part, yes. 

Thanks,
Andreas
