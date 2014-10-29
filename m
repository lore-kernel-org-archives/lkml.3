Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbaJ2UOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:14:25 -0400
Received: from admin.compro.net ([12.186.155.30]:51051 "HELO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757183AbaJ2UOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:14:22 -0400
X-BYPSHEADER: 2986634
X-SMScore: -200
Message-ID: <54514A9D.5040308@compro.net>
Date: Wed, 29 Oct 2014 16:14:21 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>
CC: lidza.louina@gmail.com, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH RESEND] staging: dgap: re-arrange functions for removing
 forward declarations
References: <20141026020853.GA28838@devel> <2027049040.1672126.1414597322410.JavaMail.root@mx2.compro.net>
In-Reply-To: <2027049040.1672126.1414597322410.JavaMail.root@mx2.compro.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 05:22 AM, Greg KH wrote:
> On Sun, Oct 26, 2014 at 11:08:54AM +0900, Daeseok Youn wrote:
>> Re-arrange the functions for removing forward declarations.
>>
>> Tested-by: Mark Hounschell <markh@compro.net>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>> RESEND: This patch is tested all by Mark.
>> It is good to merge. Greg, check please.
>
> It doesn't apply to my tree :(
>
>

Daeseok,

I will be happy to test the new patch. Somehow another patch got in 
there without us seeing it "commit: 
ac2f46c365e655dd2c366f69c609febc4ac310fd" on the list. That's why it 
doesn't apply for Greg.

Regards
Mark

