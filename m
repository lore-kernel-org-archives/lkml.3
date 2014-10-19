Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaJSRqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 13:46:55 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:41586 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaJSRqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 13:46:53 -0400
Message-ID: <5443F90A.4030606@plexistor.com>
Date: Sun, 19 Oct 2014 20:46:50 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCHSET 0/5 v2] brd: partition fixes
References: <53FDF7AD.5000709@plexistor.com> <54044759.9080103@gmail.com> <540EEE2C.1090801@plexistor.com> <540F0DDF.3010907@fb.com>
In-Reply-To: <540F0DDF.3010907@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 05:25 PM, Jens Axboe wrote:
> On 09/09/2014 06:10 AM, Boaz Harrosh wrote:
<>
>> Please tell me what you want to do with these patches. They must go into this Kernel
>> cycle before brd is released with wrong user-mode visible nub
>>
<> 
> I will drop the 3/5 patch (do that one separately) and queue up and test.
> 

Hi Jens

So the Kernel closed with a wrong knob and Even with the new merge window
these patches are not merged.

Could you at least tell me what you do not like about them so I can fix
it?

Thanks
Boaz

