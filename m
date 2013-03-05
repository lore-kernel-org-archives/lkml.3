Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab3CEJmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:42:24 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40547 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab3CEJmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:42:22 -0500
Message-ID: <5135BDF9.3080102@suse.cz>
Date: Tue, 05 Mar 2013 10:42:17 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>
CC: e1000-devel@lists.sourceforge.net,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
References: <20130129202848.GE25415@pd.tnic> <3066730.6MVSAfNyye@vostro.rjw.lan> <20130131131034.GF4926@pd.tnic> <2293454.v8QRHr8txR@vostro.rjw.lan> <20130203144656.GB5844@pd.tnic> <20130214143905.GC5700@pd.tnic> <CAErSpo6Mi31O1YA5PKnRjQMinB284Ag6PY8LuZpD0NwuZ6QZuw@mail.gmail.com> <20130214191234.GH5700@pd.tnic> <511DF7B4.8060504@openvz.org> <20130215091641.GA14387@pd.tnic> <20130304215056.GG22274@pd.tnic> <CAErSpo7Fj3zOp0S9kFrZBCe5u9r6kJUNyx+parGfoq52gWD3XQ@mail.gmail.com>
In-Reply-To: <CAErSpo7Fj3zOp0S9kFrZBCe5u9r6kJUNyx+parGfoq52gWD3XQ@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 01:16 AM, Bjorn Helgaas wrote:
> [+cc e1000-devel, Jeff, Bruce]
> 
> On Mon, Mar 4, 2013 at 2:50 PM, Borislav Petkov <bp@alien8.de> wrote:
>> On Fri, Feb 15, 2013 at 10:16:41AM +0100, Borislav Petkov wrote:
>>> So it looks Bjorn has taken most of them and the e1000e one will go
>>> through the e1000e maintainers. I'll test after the merge window is
>>> done.
>>
>> Issue still persists on 3.9-rc1 :-( :
>>
>> Mar  4 21:47:34 nazgul vmunix: [ 3223.412541] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
>> Mar  4 21:47:34 nazgul vmunix: [ 3223.412554] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
>> Mar  4 21:47:35 nazgul vmunix: [ 3224.034158] Uhhuh. NMI received for unknown reason 2c on CPU 0.
>> Mar  4 21:47:35 nazgul vmunix: [ 3224.034166] Do you have a strange power saving mode enabled?
>> Mar  4 21:47:35 nazgul vmunix: [ 3224.034168] Dazed and confused, but trying to continue
> 
> The e1000e changes didn't get merged, did they?  I don't see the
> following changes mentioned at https://lkml.org/lkml/2013/2/4/185 in
> 3.9-rc1:
> 
>       e1000e: fix pci-device enable-counter balance
>       e1000e: fix runtime power management transitions
>       e1000e: fix accessing to suspended device

You're right. They are not even in -next :(.

-- 
js
suse labs
