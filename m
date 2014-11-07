Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaKGVfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 16:35:51 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54992 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaKGVft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 16:35:49 -0500
Message-ID: <545D3B31.3030309@gmail.com>
Date: Fri, 07 Nov 2014 13:35:45 -0800
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] tty: serial: msm_serial: Use DT aliases
References: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org> <545C694D.1030204@gmail.com> <545C69E7.6010909@gmail.com> <2747100.M77UGx4AmB@wuerfel>
In-Reply-To: <2747100.M77UGx4AmB@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/2014 1:47 AM, Arnd Bergmann wrote:
> On Thursday 06 November 2014 22:42:47 Frank Rowand wrote:
>> This same change is also needed in:
>>
>>   qcom-ipq8064.dtsi
>>   qcom-msm8960.dtsi
>>   qcom-apq8084.dtsi
>>   qcom-apq8064.dtsi
>>   qcom-msm8660.dtsi
>>
>> but I did not want to just blindly apply those changes without testing.
>>
> 
> Is there only one uart on each of these?
> 
> If not, it would be better to put the aliases in the board specific file,
> pointing to whichever ports are in use, in the order that makes sense
> for that board.

Good point, thanks for bringing it up.

Your comment made me verify that the board dts files can override the
aliases from the included .dtsi.  So not a problem to have a default
set of aliases in the .dtsi files.

-Frank

