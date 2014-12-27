Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaL0XnC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 18:43:02 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34127 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaL0XnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 18:43:00 -0500
MIME-Version: 1.0
In-Reply-To: <CADZ0XgJ=LU3n55MxcHUMdX7uRcOm-m+=DFLGDi6PPkj+5=y1sg@mail.gmail.com>
References: <1419708268-14114-1-git-send-email-oscar.forner.martinez@gmail.com>
	<CACna6rxjrcpZXiv0jxmY4+EtLESYtKh=6W2RgqUDLHYy3AQ4rA@mail.gmail.com>
	<CADZ0Xg++nexnzmuaOp+MHXBbODwSpoEYNcbDU=X9tNYbzh=W-w@mail.gmail.com>
	<CADZ0XgJ=LU3n55MxcHUMdX7uRcOm-m+=DFLGDi6PPkj+5=y1sg@mail.gmail.com>
Date: Sun, 28 Dec 2014 00:42:59 +0100
Message-ID: <CACna6ry78Gs5PTUxjXy+tZAS-DNzTmqrSmwa_EVYRO6L-5_3ZA@mail.gmail.com>
Subject: Re: [PATCH] bcma: fix three coding style issues, more than 80
 characters per line
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 December 2014 at 23:04, Oscar Forner Martinez
<oscar.forner.martinez@gmail.com> wrote:
> 2014-12-27 21:14 GMT+00:00 Oscar Forner Martinez
> <oscar.forner.martinez@gmail.com>:
>>
>> 2014-12-27 20:19 GMT+00:00 Rafał Miłecki <zajec5@gmail.com>:
>>>
>>> On 27 December 2014 at 20:24, Oscar Forner Martinez
>>> <oscar.forner.martinez@gmail.com> wrote:
>>> > Three lines with more than 80 characters per line have been split in
>>> > several lines.
>>>
>>> Thanks for the next version :)
>>>
>>> 1) You missed version number. Something like
>>> git format-patch --subject-prefix="PATCH V3"
>>> (you saying for the future).
>>
>>
>> Yes, sorry I forgot to put -v 3 in git format-patch.
>>
>>>
>>>
>>> 2) I'm OK with your changes, but when checking the patch I get some
>>> errors like
>>> ERROR: trailing whitespace
>>> ERROR: DOS line endings
>>> (I used ./scripts/checkpatch.pl, see attached checkpatch log).
>>>
>>> I think that "trailing whitespace" errors are caused by DOS line
>>> endings, because I don't see anything wrong about your code.
>>>
>>> Is there something wrong with your emacs? git-send-email shouldn't
>>> malform patches I believe.
>>
>>
>> When I run ./scripts/checkpatch.pl with my patch does not show any error
>> (please find attached the output). I will try to run it with the one from my
>> e-mail. My only configuration in the .emacs file is: (setq c-default-style
>> "linux").
>
>
> I ran the ./scripts/checkpatch.pl with the patch got it from
> http://marc.info/?l=linux-wireless&m=141970834908165 and it does not show
> any error. Could you please tell me how I have to check in the same way as
> you did?

False alarm, sorry. GMail changed sth again or my browser
change/update broke saving e-mails.

-- 
Rafał
