Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab3BOREJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:04:09 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:64781 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3BOREF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:04:05 -0500
Message-ID: <511E6A82.9010301@lwfinger.net>
Date: Fri, 15 Feb 2013 11:04:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the  tree
References: <20130215160124.52d9bfb269ad1ffd390d4851@canb.auug.org.au> <20130215052421.GA3789@kroah.com>
In-Reply-To: <20130215052421.GA3789@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 11:24 PM, Greg KH wrote:
> On Fri, Feb 15, 2013 at 04:01:24PM +1100, Stephen Rothwell wrote:
>> Hi Greg,
>>
>> Today's linux-next merge of the driver-core tree got a conflict in
>> drivers/net/wireless/rtlwifi/Kconfig between commit 06e7cda3ce30
>> ("rtlwifi: Rework Kconfig") from the wireless-next tree and commit
>> 6cba014857f4 ("drivers/net/wireless/rtlwifi: remove depends on
>> CONFIG_EXPERIMENTAL") from the driver-core tree.
>>
>> I fixed it up (the former is a superset of the latter, so I used that)
>> and can carry the fix as necessary (no action is required).
>
> That sounds fine, thanks.

I agree. Sorry for any conflict.

Thanks,

Larry


