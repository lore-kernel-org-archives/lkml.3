Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaEXFbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 01:31:42 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:52553 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaEXFbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 01:31:41 -0400
MIME-Version: 1.0
X-Originating-IP: [128.107.239.233]
In-Reply-To: <20140523225424.GT15585@mwanda>
References: <1400881183-23889-1-git-send-email-c@24.io>
	<20140523225424.GT15585@mwanda>
Date: Fri, 23 May 2014 22:31:41 -0700
Message-ID: <CADadk9EPBdPBWtDEr5cmokcogrqPZzpsPrAY4pTbEiuRcJeD9w@mail.gmail.com>
Subject: Re: [PATCH] Staging: Silicom: Bypasslib: Fixed a couple of
 checkpatch.pl warnings
From: Chaitanya Hazarey <c@24.io>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        christoph.kohl@t-online.de, michael.hoefler@studium.uni-erlangen.de,
        rupert@rmuch.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dan,

Thanks for your patience, I have resubmitted via a new email. Hope that works.

Thanks,

Chaitanya

On Fri, May 23, 2014 at 3:54 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Fri, May 23, 2014 at 02:39:43PM -0700, Chaitanya Hazarey wrote:
>> Added a blank line after declarations to fix the following warnings issued by checkpatch.pl:
>>
>> drivers/staging/silicom/bypasslib/bypass.c:138: WARNING: Missing a blank line after declarations
>> drivers/staging/silicom/bypasslib/bypass.c:189: WARNING: Missing a blank line after declarations
>>
>> Signed-off-by: Chaitanya Hazarey <c@24.io>
>
> Still doesn't apply, I'm afraid.
>
>> ---
>>  drivers/staging/silicom/bypasslib/bypass.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/staging/silicom/bypasslib/bypass.c b/drivers/staging/silicom/bypasslib/bypass.c
>> index a58251f..8e714a8 100644
>> --- a/drivers/staging/silicom/bypasslib/bypass.c
>> +++ b/drivers/staging/silicom/bypasslib/bypass.c
>> @@ -135,6 +135,7 @@ static int doit(int cmd, int if_index, int *data)
>>  static int is_dev_sd(int if_index)
>>  {
>>       int ret = 0;
>> +
>>       SET_BPLIB_INT_FN(is_bypass, int, if_index, ret);
>>       return ret >= 0 ? 1 : 0;
>>  }
>> @@ -186,6 +187,7 @@ static int is_bypass_dev(int if_index)
>>  static int is_bypass(int if_index)
>>  {
>>       int ret = 0;
>> +
>>       SET_BPLIB_INT_FN(is_bypass, int, if_index, ret);
>>       if (ret < 0)
>
> There was supposed to be a blank line between the call to
> SET_BPLIB_INT_FN() and the return check and it got deleted for some
> reason.
>
> regards,
> dan carpetner
>
>
