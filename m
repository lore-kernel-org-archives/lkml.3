Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988Ab3FTI1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:27:33 -0400
Received: from intranet.asianux.com ([58.214.24.6]:57954 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3FTI1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:27:19 -0400
X-Spam-Score: -100.8
Message-ID: <51C2BCB3.4060603@asianux.com>
Date: Thu, 20 Jun 2013 16:26:27 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: timer: looping issue, need reset variable 'found'
References: <51B4A408.4050909@asianux.com> <alpine.LFD.2.02.1306101501160.22970@ionos> <51C039A8.5000903@asianux.com> <alpine.DEB.2.02.1306200944530.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306200944530.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 03:47 PM, Thomas Gleixner wrote:
> On Tue, 18 Jun 2013, Chen Gang wrote:
>> > On 06/10/2013 10:12 PM, Thomas Gleixner wrote:
>> > I think we can treat original implementation as for speed optimization,
>> > so our discussion is "whether this speed optimization has effect with
>> > correctness".
> Then I recommend that you to sit down and analyze the correctness of
> the code.

That is only your recommend, not mean I have duty to.

> 
> Come back when you have a proof of the code being wrong. And by proof
> I mean factual proof not just handwaving theories.


At least before say so, please reply:

-------------------------------------------------------------------------------
If we assume "If there is nothing in tv2 which might come before the
found timer, then any timer in tv3 will ..." is correct.

When we found a timer in 'tv1', we will not search all timers in 'tv2'
(we only search first looping of tv2 for the specific 'slot').

Is it still OK ?
-------------------------------------------------------------------------------


If you do not want to discuss with others, better quite politely, not
need judging or checking others, it is useless for the cooperation with
each other, is it right ?  ;-)


Thanks.
-- 
Chen Gang

Asianux Corporation
