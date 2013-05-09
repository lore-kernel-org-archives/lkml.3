Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3EIGiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 02:38:15 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59473 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3EIGiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 02:38:13 -0400
X-IronPort-AV: E=Sophos;i="4.87,639,1363158000"; 
   d="scan'208";a="45629366"
Message-ID: <6a3ae402d24ff869517c73209b1edb79.squirrel@www.codeaurora.org>
In-Reply-To: <CALMYJDsYSfDjZ6pug3cZ+wkFaL0VcZnNMk11DFAW7Ay56PjbdA@mail.gmail.com>
References: <1368022782-27178-1-git-send-email-draviv@codeaurora.org>
    <CALMYJDsYSfDjZ6pug3cZ+wkFaL0VcZnNMk11DFAW7Ay56PjbdA@mail.gmail.com>
Date: Wed, 8 May 2013 23:38:13 -0700
Subject: Re: [PATCH V2] scsi: ufs: Add fDeviceInit set flag during
 initialization
From: "Dolev Raviv" <draviv@codeaurora.org>
To: "Santosh Y" <santoshsy@gmail.com>
Cc: "Dolev Raviv" <draviv@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "Sujit Reddy Thumma" <sthumma@codeaurora.org>,
        "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> + */
>> +int ufshcd_query_request(struct ufs_hba *hba,
>> +                       struct ufs_query_req *query,
>> +                       u8 *descriptor,
>> +                       struct ufs_query_res *response,
>> +                       int timeout,
>> +                       int retries)
>> +{
>> +       struct scsi_device *sdev;
>> +       u8 cmd[UFS_QUERY_CMD_SIZE] = {0};
>> +       int result;
>> +       bool sdev_lookup = true;
>> +
>> +       if (!hba || !query || !response) {
>> +               dev_err(hba->dev,
>
> Please fix the static checker warnings mentioned by Dan in the previous
> mail.
> Re-base it on Seungwon's V4 patch series and you can add my Acked-by:
> Santosh Y <santoshsy@gmail.com>
>

The fix is ready.
I have to base it on top of Sujit's patch since it is inserted in the flow
he introduced.

>
>
> --
> ~Santosh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Dolev
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation



