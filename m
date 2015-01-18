Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbbARORw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:17:52 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33053 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbbARORv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:17:51 -0500
MIME-Version: 1.0
In-Reply-To: <20150117223312.GA15083@kroah.com>
References: <1420865403-4932-1-git-send-email-jkhasdev@gmail.com>
	<20150117223312.GA15083@kroah.com>
Date: Sun, 18 Jan 2015 19:47:50 +0530
Message-ID: <CAN-6CVnkeaVMOWjyx8N-R3uK4N48PficrCgSt7_0_NX0r3-5hg@mail.gmail.com>
Subject: Re: [PATCH v7] Staging: comedi: patch to fix line over 80 characters warning
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will you give reason for not apply my patch on your tree. I have
tested by appling on linux main tree.


On Sat, Jan 10, 2015 at 10:20:03AM +0530, jitendra kumar khasdev wrote:
> This is patch to pcl812.c that fix line over 80 characters warning
> which is found by checkpatch.pl tool. Reduce the extra space around
> equal sign that fix warning.

Regards,
JItendra kumar khasdev,
jitendra-02.github.io | Mo. 8871242083


On 1/18/15, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Jan 10, 2015 at 10:20:03AM +0530, jitendra kumar khasdev wrote:
>> This is patch to pcl812.c that fix line over 80 characters warning
>> which is found by checkpatch.pl tool. Reduce the extra space around
>> equal sign that fix warning.
>>
>> Signed-off-by: Jitendra kumar khasdev <jkhasdev@gmail.com>
>> ---
>>  drivers/staging/comedi/drivers/pcl812.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Does not apply to my tree :(
>
