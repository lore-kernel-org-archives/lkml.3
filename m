Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab3CMJNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:13:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57575 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab3CMJNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:13:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130313.043343.704615564539285477.davem@davemloft.net>
References: <20130312223122.884099393@linuxfoundation.org>
	<CAHsu+b9O+JG=v6FgAEG4KOVDGScFiZYQm_nqXOQ9NSae3D3hwA@mail.gmail.com>
	<20130313.043343.704615564539285477.davem@davemloft.net>
Date: Wed, 13 Mar 2013 10:13:07 +0100
Message-ID: <CAHsu+b_kMNmVB3HPtPV0re7civd_6uA_CHnbZJ5OjP8iOo=E9g@mail.gmail.com>
Subject: Re: [ 000/100] 3.8.3-stable review
From: Andre Heider <a.heider@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 9:33 AM, David Miller <davem@davemloft.net> wrote:
> From: Andre Heider <a.heider@gmail.com>
> Date: Wed, 13 Mar 2013 09:02:46 +0100
>
>> On Tue, Mar 12, 2013 at 11:30 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>> This is the start of the stable review cycle for the 3.8.3 release.
>>> There are 100 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>
>> Hi,
>>
>> I'm missing a drivers/net/ethernet/atheros/atl1c patch, namely "atl1c:
>> restore buffer state".
>> In fact, it seems the whole netdev stable patch queue is missing:
>> http://patchwork.ozlabs.org/bundle/davem/stable/?state=*
>>
>> Unsure what the workflow is here, how are these supposed to make to stable?
>
> I submit those patches at a time of my own choosing, and if you
> read stable@vger.kernel.org you will see when I do that.
>
> I let patches cook in Linus's tree for a week or so before submitting
> to -stable so that any bugs in those changes are more likely to be
> discovered before the change is in -stable too.

I hoped that a fix I care about makes it to 3.8.3, but ok, that makes sense.

Thanks,
Andre
