Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422AbaGEDdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 23:33:55 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:64080 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbaGEDdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 23:33:54 -0400
MIME-Version: 1.0
In-Reply-To: <1404530647.5148.21.camel@marge.simpson.net>
References: <CAPDOMVgP5WBDqQTLFi=PNY1ykBR1c0QnQdPYYAmN8cDYnknFbQ@mail.gmail.com>
	<1404530647.5148.21.camel@marge.simpson.net>
Date: Fri, 4 Jul 2014 23:33:53 -0400
Message-ID: <CAPDOMVj+KVO7D977gDKz-ZzJuq2wKawjT0E7TphybyYX0QF1rg@mail.gmail.com>
Subject: Re: Scalability Question
From: Nick Krause <xerofoify@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The most powerful super computer runs Ubuntu with over 3.2 million cores.
There fore I can state that Linux is very good at scaling as I have seem
the other side with embedded systems.
Cheers Nick

On Fri, Jul 4, 2014 at 11:24 PM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
> On Fri, 2014-07-04 at 16:40 -0400, Nick Krause wrote:
>> I am curious after reading some outdated kernel papers, how scalable
>> is the kernel of
>> late? I am curious mostly in memory and cpu subsystems as file systems
>> will change
>> based on user's choice.
>
> You can currently configure for up to 8192 CPUs.  I've not seen any
> benchmark data whatsoever for huge boxen, have no idea where which
> subsystem crumbles.  SGI asked for the increase to 8192, so presumably
> do manage to squeeze acceptable performance out of size XXXXL boxen.
>
> -Mike
>
