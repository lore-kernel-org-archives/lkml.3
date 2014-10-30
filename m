Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719AbaJ3Ot3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:49:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760141AbaJ3Ot1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:49:27 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: "Sharma\, Sanjeev" <Sanjeev_Sharma@mentor.com>
Cc: "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging:rtl8723au: core: Fix error reported by checkpatch.
References: <1414396745-8845-1-git-send-email-sanjeev_sharma@mentor.com>
	<wrfjioj5aonx.fsf@redhat.com>
	<FDC088D3B5555644AE135ED28A7ABDE950E890BC@EU-MBX-02.mgc.mentorg.com>
Date: Thu, 30 Oct 2014 15:49:14 +0100
In-Reply-To: <FDC088D3B5555644AE135ED28A7ABDE950E890BC@EU-MBX-02.mgc.mentorg.com>
	(Sanjeev Sharma's message of "Wed, 29 Oct 2014 06:32:48 +0000")
Message-ID: <wrfj38a51ul1.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com> writes:
> -----Original Message-----
> From: Jes Sorensen [mailto:Jes.Sorensen@redhat.com] 
> Sent: Monday, October 27, 2014 2:13 PM
> To: Sharma, Sanjeev
> Cc: Larry.Finger@lwfinger.net; gregkh@linuxfoundation.org;
> linux-wireless@vger.kernel.org; devel@driverdev.osuosl.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] staging:rtl8723au: core: Fix error reported by checkpatch.
>
> Sanjeev Sharma <sanjeev_sharma@mentor.com> writes:
>> This is a patch to the rtw_cmd.c file that fixes Error reported by 
>> checkpatch.
>>
>> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
>> ---
>>  drivers/staging/rtl8723au/core/rtw_cmd.c | 83 
>> +++++++++++++++-----------------
>>  1 file changed, 40 insertions(+), 43 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c 
>> b/drivers/staging/rtl8723au/core/rtw_cmd.c
>> index 4eaa502..c1f6254 100644
>> --- a/drivers/staging/rtl8723au/core/rtw_cmd.c
>> +++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
>> @@ -957,7 +957,7 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
>>  		/*  check traffic for  powersaving. */
>>  			if (((pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod +
>>  			      pmlmepriv->LinkDetectInfo.NumTxOkInPeriod) > 8) ||
>> -			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod >2)
>> +			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod > 2)
>>  				bEnterPS = false;
>>  			else
>>  				bEnterPS = true;
>
> This makes the line longer than 80 characters, that is worse than the 'problem' you are fixing.
>
> Jes
>
> Hello jes,
>
> How it can be worse because checkpatch treating this as an Error and
> line longer than 80 character is warning reported by checkpatch and I
> could see that in entire staging directory, 
> every maintainer most of the time ignore the 80 column limit and give
> priority to Error. 
>
> Please let me know your comment .
>
> Sanjeev Sharma 

checkpatch has it's ideas, doesn't mean it's blindly right at all
times. In this particular case it keeps the code more readable to keep
it below 80 characters than it does to add those two blanks and make the
line longer.

I agree the long variable names are nasty, and it doesn't help they were
done in StUdLyCaPs. If you want to attack it from that front, please go
ahead.

However, on formatting, please respond with proper email using proper
quoting when replying.

Thanks,
Jes
