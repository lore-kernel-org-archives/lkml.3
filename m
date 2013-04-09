Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762938Ab3DINJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:09:17 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51844 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169Ab3DINJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:09:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130409125817.GC12244@kernel.dk>
References: <1364698505-22236-1-git-send-email-linkinjeon@gmail.com>
	<20130409125817.GC12244@kernel.dk>
Date: Tue, 9 Apr 2013 22:09:11 +0900
Message-ID: <CAKYAXd-GSDkbKRkr4W6hP6+PjrxSbaLqP9DQ3yYpoOByyAfQjw@mail.gmail.com>
Subject: Re: [PATCH] Documentation: cfq-iosched: update documentation help for
 cfq tunnables
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: rob@landley.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/9 Jens Axboe <axboe@kernel.dk>:
> On Sun, Mar 31 2013, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Add the documentation text for latency, target_latency & group_idle
>> tunnable parameters in the block/cfq-iosched.txt.
>> Also fix few typo(spelling) mistakes.
>
> Thanks, merged with various fixups to the language. You can see the end-result
> here:
Thanks Jens !. I checked.
>
> http://git.kernel.dk/?p=linux-block.git;a=commit;h=fdc6fdc52e4630f5020281ce5450be7cc1887de2
>
> --
> Jens Axboe
>
