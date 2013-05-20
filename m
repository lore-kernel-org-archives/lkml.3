Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab3ETCnj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 22:43:39 -0400
Received: from intranet.asianux.com ([58.214.24.6]:37122 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab3ETCni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 22:43:38 -0400
X-Spam-Score: -100.8
Message-ID: <51998DA8.70609@asianux.com>
Date: Mon, 20 May 2013 10:42:48 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ming Lei <tom.leiming@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Consult] Why need we call device_remove_file() firstly before
 call device_unregister() ?
References: <5195C39F.9010101@asianux.com> <CACVXFVNiWwiXtubJSbE3z6-AyxcOBgyvhn+2diHyi5Nyj4XYeg@mail.gmail.com> <5199765F.5000905@asianux.com> <20130520014506.GA2201@kroah.com> <51998699.4080202@asianux.com> <20130520022016.GA2945@kroah.com>
In-Reply-To: <20130520022016.GA2945@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 10:20 AM, Greg Kroah-Hartman wrote:
> On Mon, May 20, 2013 at 10:12:41AM +0800, Chen Gang wrote:
>> > I mean that if no reply by any other members within a week, I will know
>> > it is correct that "we need not call device_remove_file() firstly before
>> > call device_unregister()" (at least, one member's reply supports this
>> > conclusion).
>> > 
>> > I find this 'question' when discussing a patch with another members in
>> > linux-kernel@vger.kernel.org, I have read the related code and also have
>> > searched with google, but can not find the result, so I want to consult
>> > it in linux-kernel@vger.kernel.org.
> Asking random questions on lkml, and relying on the fact that no one
> else happens to say anything, is not any judge as to if the answer is
> correct at all.
> 

OK, I can understand, now, thank you for your reply.

And I wish, we can provide the confirmation of all related questions
about Linux kernel, in the future,


> In fact, just asking questions on lkml has a very low chance of ever
> getting a correct answer, given that the people that usually do know the
> answer to these types of things are usually:
>   1) not reading lkml because they are busy doing real work

I should understand, they have no duty to have to reply the related
mail, especially every members already have their own work (and
normally, they are really busy).


>   2) annoyed by questions that are easily answered by themselves by
>      either:
>        a) reading the code

I have done, so I need not worry about this item. :-)

>        b) writing a simple example module and testing it out yourself
> 

Precisely, I did not do it firstly. It seems I should do it firstly
(although, at least now, I do not think it will get any valuable result
for our this case)

> 
> Good luck,
> 

OK, 'Lucky' is really the first important !!

I should continue to analyze this question, independent this 'consult' mail.


Thanks.
-- 
Chen Gang

Asianux Corporation
