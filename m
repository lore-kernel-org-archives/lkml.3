Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3CKKJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:09:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49277 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab3CKKJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 06:09:36 -0400
Message-ID: <513DAD5D.6040905@gmail.com>
Date: Mon, 11 Mar 2013 11:09:33 +0100
From: Harald Arnesen <skogtun.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [3.9-rc1] very poor interrupt responses
References: <2663178.G2EStYDi2n@segfault.sh0n.net> <7791757.cgjzv69Ulu@vostro.rjw.lan>
In-Reply-To: <7791757.cgjzv69Ulu@vostro.rjw.lan>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki [2013-03-11 04:38]:

> On Friday, March 08, 2013 02:12:33 PM Shawn Starr wrote:
>> Hello folks,
>>
>> I am noticing since rc0 and now rc1, very poor interrupt handling. Keyboard response, mouse movements, display refreshing etc. General input/display sluggishness. Did something break IRQ handling somewhere? I need to validate if this happens with X not running also if it is i915 related somehow. The behavor is noticed in a console login however.
> 
> Please try to disable the intel_pstate driver by putting intel_pstate=disable
> into the kernel's command line and see if that helps (you may also try to
> compile the driver out).

I see the same problem on my Thinkpad T500, and I have
X86_INTEL_PSTATE=n in my config.
-- 
Hilsen Harald
