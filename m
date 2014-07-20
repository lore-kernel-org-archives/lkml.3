Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaGTKm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 06:42:59 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.24]:36900 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaGTKm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 06:42:58 -0400
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1405817480-25347-1-git-send-email-peter@piie.net> <1405817480-25347-2-git-send-email-peter@piie.net> <20140720080420.GA28707@rhlx01.hs-esslingen.de>
Message-ID: <cone.1405852973.378940.3229.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Andreas Mohr <andi@lisas.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 1/6] acerhdf: Adding support for
         =?UTF-8?B?Im1hbnVhbCBtb2RlIg==?=
Date: Sun, 20 Jul 2014 12:42:53 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

Andreas Mohr writes:

> Hi
> 
> On Sun, Jul 20, 2014 at 02:51:15AM +0200, Peter Feuerer wrote:
>> @@ -127,105 +138,107 @@ struct bios_settings_t {
>>  	unsigned char fanreg;
>>  	unsigned char tempreg;
>>  	struct fancmd cmd;
>> +	int mcmd_enable;
>>  };
>>  
>> +
>>  /* Register addresses and values for different BIOS versions */
>>  static const struct bios_settings_t bios_tbl[] = {
> 
> Change-unrelated content here, might want to move away.

You mean this newline?


> Suggestion (if ok from a commit revision/history POV):
> git rebase -i s:/'acerhdf: Adding support for "manual mode"'~1
> <"e"dit first commit>
> git checkout -p s:/'acerhdf: Adding support for "manual mode"'
> <grab hunk [split as needed]>
> git commit -m "FIXUP"
> git rebase --continue
> git rebase -i s:/'acerhdf: Adding support for "manual mode"'~1
> <move FIXUP line post [PATCH v4 6/6] acerhdf: minor clean up>
> <do "f"ixup>

If I understand this correctly, you want me to move this new line
to patch 6, correct?


> Sorry that I didn't find worse breakage during my review
> than this si{mp|ng}le line ;)

No problem, as long as you give your Acked-by / Reviewed-by ;)

--peter;
