Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaLEOJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:09:17 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:47350 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaLEOJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:09:13 -0500
MIME-Version: 1.0
In-Reply-To: <20141205140011.GA5184@hudson.localdomain>
References: <1417787034-7833-1-git-send-email-andnlnbn18@gmail.com>
	<20141205140011.GA5184@hudson.localdomain>
Date: Fri, 5 Dec 2014 19:39:12 +0530
Message-ID: <CAFnntG3orLhA5tOHM+k3JMbCo7Atinq_1gaWPBR6CySqw7ytMA@mail.gmail.com>
Subject: Re: [PATCH] watchdog: Fixed missing blank line warning
From: Athira Lekshmi C V <andnlnbn18@gmail.com>
To: Jeremiah Mahler <jmmahler@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Should I resubmit the above patch again including the version number,
or can I start doing so from the next time onwards ?

Thank You
Athira Lekshmi

On Fri, Dec 5, 2014 at 7:30 PM, Jeremiah Mahler <jmmahler@gmail.com> wrote:
> Athira,
>
> On Fri, Dec 05, 2014 at 07:13:54PM +0530, Athira Lekshmi wrote:
>> Fixed the checkpatch warning:
>> Missing a blank line after declarations
>>
>> Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
>> ---
>>  drivers/watchdog/mixcomwd.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/watchdog/mixcomwd.c b/drivers/watchdog/mixcomwd.c
>> index be86ea3..03b7612e 100644
>> --- a/drivers/watchdog/mixcomwd.c
>> +++ b/drivers/watchdog/mixcomwd.c
>> @@ -183,6 +183,7 @@ static ssize_t mixcomwd_write(struct file *file, const char __user *data,
>>
>>                       for (i = 0; i != len; i++) {
>>                               char c;
>> +
>>                               if (get_user(c, data + i))
>>                                       return -EFAULT;
>>                               if (c == 'V')
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> It is helpful to add a version number when patches are re-submitted to
> avoid them being confused for a new patch.  git-format-patch has the
> --reroll-count option which makes this easy to do.
>
> --
> - Jeremiah Mahler
