Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaI3Rx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:53:26 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:57094 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaI3RxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:53:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5DOph+nX6UChuWcBnZ_To6=H96ObH0RdYND4g6ooptaeQ@mail.gmail.com>
References: <1412097587-2779-1-git-send-email-karthik.188@gmail.com> <CAOMZO5DOph+nX6UChuWcBnZ_To6=H96ObH0RdYND4g6ooptaeQ@mail.gmail.com>
From: karthik nayak <karthik.188@gmail.com>
Date: Tue, 30 Sep 2014 23:23:03 +0530
Message-ID: <CAOLa=ZRf1j57vyqzkFVw1GVjyh==CY9iYtssHSnejgYf_+qt3Q@mail.gmail.com>
Subject: Re: [PATCH] staging: et131x: remove unneccessary 'out of memory' message
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        gamerh2o@gmail.com, Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, i sent the old commit again, sorry!
Regards,
Karthik Nayak


On Tue, Sep 30, 2014 at 11:10 PM, Fabio Estevam <festevam@gmail.com> wrote:
> On Tue, Sep 30, 2014 at 2:19 PM, Karthik Nayak <karthik.188@gmail.com> wrote:
>> Removes the 'out of memory' warning issues by checkpatch
>>
>> Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
>> ---
>>  drivers/staging/et131x/et131x.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
>> index 41fcaa0..f1a9296 100644
>> --- a/drivers/staging/et131x/et131x.c
>> +++ b/drivers/staging/et131x/et131x.c
>> @@ -2423,7 +2423,6 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
>>
>>         skb = dev_alloc_skb(rfd->len + 2);
>>         if (!skb) {
>> -               dev_err(&adapter->pdev->dev, "Couldn't alloc an SKB for Rx\n");
>>                 return NULL;
>>         }
>
> Then you could also remove the braces:
>
> if (!skb)
>       return NULL;
