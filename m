Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaIYTfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:35:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41026 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaIYTfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:35:31 -0400
Message-ID: <54246E82.1050305@infradead.org>
Date: Thu, 25 Sep 2014 12:35:30 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Frans Klaver <fransklaver@gmail.com>, Oscar Utbult <oscar@oscr.io>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Changed "&" with "and" in Documentation/applying-patches.txt.
References: <1411652495-100852-1-git-send-email-oscar@oscr.io> <CAH6sp9NqiNincavwB9bQ94EvG8ZjvUPLH5u3j04OV2JMz7wTEg@mail.gmail.com> <e692e73445c591af1bea3ce0a87755c6@oscr.io> <20140925191254.GA2073@gmail.com>
In-Reply-To: <20140925191254.GA2073@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/14 12:12, Frans Klaver wrote:
> On Thu, Sep 25, 2014 at 06:28:47PM +0200, Oscar Utbult wrote:
>> On 2014-09-25 16:48, Frans Klaver wrote:
>>> On Thu, Sep 25, 2014 at 3:41 PM,  <oscar@oscr.io> wrote:
>>>> Subject: [PATCH 1/1] Changed "&" with "and" in 
>>>> Documentation/applying-patches.txt.
>>>
>>> Documentation/SubmittingPatches says:
>>>
>>> Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
>>> instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
>>> to do frotz", as if you are giving orders to the codebase to change
>>> its behaviour.
>>
>> Thank you for your feedback Frans.
>>
>> So for example a better description would have been: "use 'and' instead 
>> of '&'"?
> 
> Yes. It is useful to still mention it is affecting documentation only
> though. This helps identifying whether a change may be related to a
> defect for example.
> 
> By the way, I just grepped through the documentation, and there are
> quite some situations where this same change would happen, so if we care
> enough, all those instances could be changed. I don't know if we care
> enough though. That's for others, like Randy, to decide.

I think that we don't care enough.  The referenced web page talks about
formal documentation.  We aren't quite formal IMO.


-- 
~Randy
