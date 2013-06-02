Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3FBQxB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 12:53:01 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60182 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3FBQwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 12:52:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130602115634.GA15561@dhcp-26-207.brq.redhat.com>
References: <20130531125910.GA1454@dhcp-26-207.brq.redhat.com>
 <20130531223024.AB12F3E08FE@localhost> <20130602115634.GA15561@dhcp-26-207.brq.redhat.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 2 Jun 2013 17:52:21 +0100
X-Google-Sender-Auth: UXW5u4Omsq-V91Cnk2eRP0EyyfI
Message-ID: <CACxGe6uWZxb_ZeSoYDOOaA9+DqSCDd+zM8SQfpKkeiCmHoUNkA@mail.gmail.com>
Subject: Re: [PATCH] irqdomain: Do not reuse existing mappings
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 2, 2013 at 12:56 PM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Fri, May 31, 2013 at 11:30:24PM +0100, Grant Likely wrote:
>> On Fri, 31 May 2013 14:59:11 +0200, Alexander Gordeev <agordeev@redhat.com> wrote:
>> What exactly is the problem that you're trying to solve with this patch?
>> It's not clear from the description.
>
> Hi Grant,
>
> Thanks for the clarification!
>
> No particular problem - I just was confused with this particular behaviour
> and failed to put RFC in subject line. Sorry for that.

Hi Alexander,

So there isn't an actual bug or problem that you're trying to solve?
If you've got a problem on a real system then I'd like to know about
it.

g.
