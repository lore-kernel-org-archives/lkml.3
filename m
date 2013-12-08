Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796Ab3LHRvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 12:51:00 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47800 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab3LHRu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 12:50:58 -0500
Message-ID: <52A4B17F.6050809@gmail.com>
Date: Sun, 08 Dec 2013 10:50:55 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, namhyung@kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 2/2] perf probe: Allow user to specify address within
 executable
References: <1385942827-11637-1-git-send-email-dsahern@gmail.com> <1385942827-11637-2-git-send-email-dsahern@gmail.com> <529C259D.8010901@hitachi.com> <529C9DDF.1080401@gmail.com> <529CC97A.6000807@gmail.com> <529DA355.9090408@hitachi.com> <529DFF8E.2030806@gmail.com> <529E83C0.1060405@hitachi.com> <529E8903.7060907@gmail.com> <529EDC36.5050108@hitachi.com>
In-Reply-To: <529EDC36.5050108@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/4/13, 12:39 AM, Masami Hiramatsu wrote:
> What would you like to do with perf probe? Direct address accessing for
> userspace is not a good way to do, because userspace is relocatable...

Masami, I am referring to the address within the executable which is
what perf-probe pushes to the kernel.

> 
>> For now I will carry the patch locally. At this point I am 20 patches
>> deep and have probably another 20 to go. What's one more. I'll come back
>> to this when I have more time.
> 
> Would you have any public git repository for that?

https://github.com/dsahern/linux/tree/perf-full-monty


 And could you share
> us what would you like to do before sending patch? We can help you to
> tell the best way.

I want to save myself some time and effort by giving the relative
address with an executable. That allows me to probe any function, and I
want to do it from a consistent user interface -- perf-probe. With the
proposed patch I have that.

David
