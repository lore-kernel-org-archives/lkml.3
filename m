Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3EVVNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:13:04 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:37626 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3EVVNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:13:02 -0400
Message-ID: <519D34D4.1010402@redhat.com>
Date: Wed, 22 May 2013 23:12:52 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com> <519C674A.50700@redhat.com> <20130522093249.GC3466@mtj.dyndns.org> <519C959A.3090100@redhat.com> <20130522100212.GE3466@mtj.dyndns.org> <519C9CBC.3050003@redhat.com> <20130522134134.GA15189@mtj.dyndns.org> <519CD234.40608@redhat.com> <20130522150335.GC2777@thunk.org> <519CE9FE.2030007@redhat.com> <20130522203906.GC23845@mtj.dyndns.org>
In-Reply-To: <20130522203906.GC23845@mtj.dyndns.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/05/2013 22:39, Tejun Heo ha scritto:
> Hey,
> 
> On Wed, May 22, 2013 at 05:53:34PM +0200, Paolo Bonzini wrote:
>> I do listen to review feedback, but I also expect the other side to
>> listen to me, ask me what is not clear, and possess some knowledge of
>> the domain that he's reviewing patches for.  All of which, quite
>> frankly, I have not seen in this case.
> 
> Heh, nice one.  As we've talked on RH mailing list, I don't doubt this
> has been a pretty bad experience for you but it also has been one of
> the worst review experiences for me too.

I can imagine.  Sorry about that.

> I'm not saying you don't listen to reviews at all but the reception
> definitely feels very low-gain.

Frankly, I can say the same with s/reviews/explanations/...

> Anyways, at this point, the easiest way to make forward progress is
> completely separating out security fix from the rest along with the
> "count me out" knob, which should be able to cover most of the
> described use cases anyway.  Let's please do further modifications to
> the filtering table as a separate step.

Okay, we seem to have reverted (both of us) to a more civil tone, and I
appreciate setting a way forward.

I'll send three separate series in the next few days.  I guess it's okay
to send the common patch twice.

Paolo
