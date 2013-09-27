Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3I0HSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 03:18:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14098 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3I0HSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 03:18:07 -0400
X-Spam-Score: -100.8
Message-ID: <524530EB.6080109@asianux.com>
Date: Fri, 27 Sep 2013 15:16:59 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info'
 in all related extern functions
References: <5242331B.4010309@asianux.com> <20130925005802.GA25777@htj.dyndns.org> <5242372C.4010509@asianux.com> <20130925011404.GB25777@htj.dyndns.org> <52424094.3020504@asianux.com> <524267CD.4030007@asianux.com> <5243CD18.1060805@asianux.com> <5243D487.8000602@asianux.com> <20130926131544.GB31249@mtj.dyndns.org> <5244DFA5.5090200@asianux.com> <20130927033651.GA9768@htj.dyndns.org>
In-Reply-To: <20130927033651.GA9768@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Firstly, thank you for your so much contents reply.


On 09/27/2013 11:36 AM, Tejun Heo wrote:
> Hello, Chen.
> 
> On Fri, Sep 27, 2013 at 09:30:13AM +0800, Chen Gang wrote:
>> As an integrator or large source code maintainer, we cannot only depend
>> on testing, or tracing log, or some short directly causes; we also need
>> find and solve issues by checking sub-systems' interface or documents.
> 
> Do you seriously think that you're the only one thinking the above?
> You're repeating something obvious.  The problem is that that's *all*
> you're doing.  Anyone who has *some* coding experience would know that
> and you didn't move even an inch forward from there.
>
> What you have done is obvious from your initial commit message, you
> read some random piece of code, found something slightly inconsistent
> with your concept of ideal construction, grepped a bit, and whipped up
> that patch.  It's such a perfect cliche of inexperience.  It's
> something immediately obvious and *exactly* why you were asked to
> actually try out your hypothesis.  It was supposed to serve two
> purposes - either proving or disproving your patch && if your
> knee-jerk patch was wrong, which I thought was likely given the
> circumstances, making you think *why* you got it wrong and learn from
> the experience.
> 

Hmm... do you mean: "can not evaluate an interface before implement(or
read details) them all"?

In my opinion

  When define interface, need know most of demands (e.g. 80%), and also need know summary design, but don't need know about any implementation.
  When evaluate an interface which is already defined, need know about summary demands is enough (especially, we also can reference the implementation).
  Whether checking parameters belongs to interface (not only belongs to the implementation).

So, I think, at present, we have enough information to get conclusion:
"whether 'groups' interface need be improved". Before go ahead ("even
an inch"), I think it is necessary to discuss about it, firstly.


> When asked to actually verify your patch, you thought it was something
> you were unfairly asked to do, and when your previous analysis was
> shown to be wrong as so easily predicted, instead of thinking about
> why you got that wrong and learning from the experience, you're now
> just repeating the same crap in the opposite direction.
> 
> You're missing massive amount of steps between recognizing that
> something is inconsistent and producing a proper improvement for it
> and failing to recognize your shortcoming even when it failed right in
> front of your face.  You need to understand how the subsystem and code
> actually work before making changes, study the callers and history of
> the code especially if the code has been stable / stale for long
> period of time, verify your assumptions using objective measures, and
> present that in your patch.  For a patch like this, preferably with
> some risk analysis.
> 

If we are agree with each other that "this interface can be improved",
I will go ahead:

  I will reference the information which Paul McKenney provided.
  And also, I will use LTP's some features to give a test.
  And also, I will reference some contents you said above.

  Hope I can finish within next month (2013-10-31).


> So, please take some time to mull over why your initial patch was
> completely wrong and I didn't even have to read the code to predict
> that your patch has high chance of being wrong.  Now, you're doing the
> *exactly* same thing in the opposite direction.  You should be able to
> recognize that there's something very wrong with that.
> 

No, I don't think so, in my opinion, for evaluate an api interface,
don't need see the details implementation, even don't need know all
demands.

During discussing, anyone can make mistakes, in fact, that is the main
reason why we need discussing.

Hmm... in my opinion, for evaluate one's way/method whether suitable or
not, it is not based on 1-2 mistakes, it need based on mistake/correct ratio.


> Thanks.
> 

Thanks.
-- 
Chen Gang
