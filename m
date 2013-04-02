Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab3DBBDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 21:03:40 -0400
Received: from intranet.asianux.com ([58.214.24.6]:12954 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3DBBDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 21:03:39 -0400
X-Spam-Score: -100.8
Message-ID: <515A2E4C.8050409@asianux.com>
Date: Tue, 02 Apr 2013 09:03:08 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: jhovold@gmail.com, Jiri Slaby <jslaby@suse.cz>, mferrell@uplogix.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: USB: mos7840: looping issue: avoid the return value overriden
 by looping
References: <5158F689.5040406@asianux.com> <20130401030555.GA21113@kroah.com> <5159041F.7020608@asianux.com> <20130401193721.GA13712@kroah.com>
In-Reply-To: <20130401193721.GA13712@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  thank you for spending your time for this patch, especially you are
very busy.

  next time, I should send patch with more careful, so can let other
members work with more efficiency.

  excuse me, the next 2-3 days, I have to do another urgent things
within my company, so I will send our patch v2 within this week (if our
patch is urgent, too, please tell me, and I should try to send it in time).

  welcome any suggestions or completions. thanks.


On 2013年04月02日 03:37, Greg KH wrote:
> Please use a "real" error value, or even better yet, use the error value
> returned from the call here.
> 

  ok, I will do.

> And please identify the driver you are modifying in the Subject: line,
> like I have changed this one to.

  ok, thanks.

  and next, I should use such kind of format for any sub systems.



-- 
Chen Gang

Asianux Corporation
