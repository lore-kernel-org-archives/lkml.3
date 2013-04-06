Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab3DFFNi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 01:13:38 -0400
Received: from intranet.asianux.com ([58.214.24.6]:58821 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3DFFNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 01:13:37 -0400
X-Spam-Score: -100.8
Message-ID: <515FAEE3.3070306@asianux.com>
Date: Sat, 06 Apr 2013 13:13:07 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: arve@android.com, Dan Carpenter <dan.carpenter@oracle.com>,
        viro@zeniv.linux.org.uk, mirsal@mirsal.fr,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Android: looping issue, need break when get
 value firstly.
References: <515E85C5.7010706@asianux.com> <20130405220156.GC31680@kroah.com>
In-Reply-To: <20130405220156.GC31680@kroah.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013Äê04ÔÂ06ÈÕ 06:01, Greg KH wrote:
> On Fri, Apr 05, 2013 at 04:05:25PM +0800, Chen Gang wrote:
>>
>>   need break when 'target_thread' get value, firstly.
>>
>>     'tmp' is a stack (thread->transaction_stack),
>>     if 'proc' was the same between child node and parent node,
>>     the child would have higher priority than parent.
> 
> Are you sure about this?
> 
> have you tested it?
> 
> greg k-h
> 
> 

  excuse me, I have not tested it.

  I find it only by reading code.
  I want to discuss it with related members.
    (although I use [PATCH] title instead of [Suggestion] title)

  if what I have done is not quite suitable, please provide suggestions.

  thanks.

-- 
Chen Gang

Asianux Corporation
