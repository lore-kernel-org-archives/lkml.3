Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbaJ3JGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:06:33 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:43188 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758311AbaJ3JG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:06:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1410300714090.2374@localhost6.localdomain6>
References: <CAB=NE6UcT9suZDfnTY09rOoqOSoYEqV2fryCSo7BjJyqXKXewQ@mail.gmail.com>
	<CAB=NE6WW5zAD_4Jqwaf2pyy5RVtt-tSAQQfDK4MFr+R+KQNi_Q@mail.gmail.com>
	<alpine.DEB.2.02.1410300714090.2374@localhost6.localdomain6>
Date: Thu, 30 Oct 2014 10:06:28 +0100
Message-ID: <CA+MoWDpwwSvC7kbKiPpcD8qAeP93COtWb7OUAaJbaKUnDSBM+A@mail.gmail.com>
Subject: Re: Tool to match kernel C file to CONFIG symbol
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        stefan.hengelein@fau.de,
        Valentin Rothberg <valentinrothberg@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a dirty and ugly Perl script that return source files for a
given set of Kconfig symbols:

https://gist.github.com/petersenna/6329591

On Thu, Oct 30, 2014 at 7:16 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>
>
> On Wed, 29 Oct 2014, Luis R. Rodriguez wrote:
>
>> On Wed, Oct 29, 2014 at 4:15 PM, Luis R. Rodriguez
>> <mcgrof@do-not-panic.com> wrote:
>> > Anyone familiar with a tool to match a specific C file to a respective
>> > CONFIG symbol on the kernel? I'd prefer if its written in C or Python.
>> > This should be easy to write if we don't have it yet.
>>
>> Peter, didn't you have such tool already?
>
> I think that the Erlangen people can help you (added to CC).
>
> I'm not sure which way you want to go: What config symbol will get my file
> compiled, or if I turn on this config symbol, what files will I get.  I
> think that Stefan's Vampyr tool can help with the first.
>
> julia



-- 
Peter
