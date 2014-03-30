Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaC3QyD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 12:54:03 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:61672 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaC3Qx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 12:53:58 -0400
Message-ID: <53384C24.6000309@gmail.com>
Date: Sun, 30 Mar 2014 12:53:56 -0400
From: Alexandre Demers <alexandre.f.demers@gmail.com>
Reply-To: alexandre.f.demers@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [Regression, bisected 9e30cc] "sysfs, kernfs: no need to kern_mount()
 sysfs from sysfs_init()" prevents system from booting correctly
References: <CAPEhTTFP3N-ReasmgL5n82mve8p8M3crqmaMvzV+F2p5JCSRbQ@mail.gmail.com> <20140314140804.GG12613@htj.dyndns.org> <CAPEhTTG3kCDk2V9dbCB5mATKt2nyVj9iiv9g5MTOEbqYrpPefg@mail.gmail.com> <20140317201346.GE17373@mtj.dyndns.org> <5327AAA8.2080703@gmail.com> <53322777.3030703@gmail.com> <20140326131800.GA7171@htj.dyndns.org> <CAPEhTTGyA7SjedwL8Mv-ZDEY_doucW3thPr==xyOemm3+Vp=Cg@mail.gmail.com> <20140329181258.GF5553@htj.dyndns.org> <5337445E.3080903@gmail.com> <20140330123128.GB8942@htj.dyndns.org>
In-Reply-To: <20140330123128.GB8942@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh boy... Maybe. I'll look at this option this week.

Alexandre Demers

On Sun 30 Mar 2014 08:31:28 AM EDT, Tejun Heo wrote:
> On Sat, Mar 29, 2014 at 06:08:30PM -0400, Alexandre Demers wrote:
>> That fixes the problem, I'm now running 3.14-rc8 with your patch
>> applied.
>
> Just sent out the patch but I think we still need to find out what's
> going on.  Is there any chance you can create a qemu image which shows
> the same behavior?
>
> Thanks.
>
