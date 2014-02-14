Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaBNV5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:57:45 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:59760 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaBNV5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:57:43 -0500
Message-ID: <52FE9154.30007@lwfinger.net>
Date: Fri, 14 Feb 2014 15:57:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Wu <lekensteyn@gmail.com>
CC: Chaoming_Li <chaoming_li@realsil.com.cn>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 3/3] rtlwifi: remove unused allow_all_destaddr functions
References: <1392401026-18417-1-git-send-email-lekensteyn@gmail.com> <1392401026-18417-4-git-send-email-lekensteyn@gmail.com> <52FE8CD8.1050409@lwfinger.net> <5255317.CRdrWcWANY@al>
In-Reply-To: <5255317.CRdrWcWANY@al>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 03:48 PM, Peter Wu wrote:
> On Friday 14 February 2014 15:38:32 Larry Finger wrote:
>> On 02/14/2014 12:03 PM, Peter Wu wrote:
>>> Unused as configure_filter takes care of setting/clearing RCR_AAP.
>>>
>>> Signed-off-by: Peter Wu <lekensteyn@gmail.com>
>>
>> NACK - at least for now. This patch has merge conflicts for the set of
>> patches that add the rtl8723be driver, and would cause build errors if the
>> merge were fixed. I will hang on to it and apply it later when the
>> rtl8723be merge is done.
>
> Fair enough, the next patch will strip even more then :-)

No harm in sending more as [RFC/RFT] items. That way they will get reviewed, and 
I will be able to test them. Once the conflicts are cleared, then I can push 
them to John with a "From" you.

Larry

