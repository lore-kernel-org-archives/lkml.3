Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab3I2VXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 17:23:42 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:47890 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab3I2VXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 17:23:40 -0400
Message-ID: <52489A59.7040108@gmail.com>
Date: Sun, 29 Sep 2013 17:23:37 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Torvalds <torvalds@osdl.org>, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH 1/1] x86_64: add config options to optimize for newer
 AMD processors
References: <52486938.4090009@gmail.com> <20130929180101.GB5490@pd.tnic> <5248905E.8000801@gmail.com> <20130929205051.GD5426@pd.tnic>
In-Reply-To: <20130929205051.GD5426@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 04:50 PM, Borislav Petkov wrote:
> On Sun, Sep 29, 2013 at 04:41:02PM -0400, Austin S Hemmelgarn
> wrote:
>> While I understand that you want decisive proof that it provides
>> an improvement, does it specifically matter if the option is
>> unused by most people and doesn't result in a negative
>> performance hit when used?
> 
> Just having the option for no good reason at all is a no-no.

I'm not saying that should just be included without substantiation, I
simply mean that the reason to include it (as far as I am concerned)
is that it doesn't break anything and provides something useful that
isn't in the kernel already.

Despite this I am still happy to benchmark it to provide some more
concrete proof.
