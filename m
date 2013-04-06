Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3DFFGa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 01:06:30 -0400
Received: from intranet.asianux.com ([58.214.24.6]:60236 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3DFFG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 01:06:29 -0400
X-Spam-Score: -100.8
Message-ID: <515FAD37.4090300@asianux.com>
Date: Sat, 06 Apr 2013 13:05:59 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Mirsal Ennaime <mirsal@mirsal.fr>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: Android: looping issue, need break when get
 value firstly.
References: <515E85C5.7010706@asianux.com> <20130405220156.GC31680@kroah.com> <CAMP5Xgd=wVrDVCc84L2kMk9ADy7avokB6D=4+kdAm8jF+NLVyg@mail.gmail.com>
In-Reply-To: <CAMP5Xgd=wVrDVCc84L2kMk9ADy7avokB6D=4+kdAm8jF+NLVyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月06日 07:48, Arve Hjønnevåg wrote:
> On Fri, Apr 5, 2013 at 3:01 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Fri, Apr 05, 2013 at 04:05:25PM +0800, Chen Gang wrote:
>>> >>
>>> >>   need break when 'target_thread' get value, firstly.
>>> >>
>>> >>     'tmp' is a stack (thread->transaction_stack),
>>> >>     if 'proc' was the same between child node and parent node,
>>> >>     the child would have higher priority than parent.
>> >
>> > Are you sure about this?
>> >
>> > have you tested it?
>> >
> Theoretically this should not change the behavior. The purpose of this
> code it to make sure only thread per process is part of a transaction
> stack, so if it finds more than one transaction with a matching
> process, they should all point to the same thread object. I think a
> better change description is needed though.


  ok, thanks.
  I will send patch v2 (also mark you as Signed-off).
    (if the patch v2 still need improvement, please reply in time).


  thanks.

  :-)

-- 
Chen Gang

Asianux Corporation
