Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab3HANBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:01:06 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2163 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab3HANBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:01:05 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <51FA5BFF.6050901@broadcom.com>
Date: Thu, 1 Aug 2013 15:00:47 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: "David Howells" <dhowells@redhat.com>
cc: "Joe Perches" <joe@perches.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andy Whitcroft" <apw@canonical.com>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "Cong Wang" <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn when using extern with function
 prototypes in .h files
References: <1374721150.1924.26.camel@joe-AO722>
 <1374602291.3387.17.camel@joe-AO722> <kspuuk$k2v$1@ger.gmane.org>
 <1374716480.1924.18.camel@joe-AO722>
 <20130725014732.GA10036@order.stressinduktion.org>
 <25105.1375359664@warthog.procyon.org.uk>
In-Reply-To: <25105.1375359664@warthog.procyon.org.uk>
X-WSS-ID: 7DE4863E2L869572949-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 02:21 PM, David Howells wrote:
> Joe Perches <joe@perches.com> wrote:
>
>> Using the extern keyword on function prototypes is superfluous
>> visual noise so suggest removing it.
>>
>> Using extern can cause unnecessary line wrapping at 80 columns
>> and unnecessarily long multi-line function prototypes.
>>
>> Suggested-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
>> Signed-off-by: Joe Perches <joe@perches.com>
>
> Nak.
>
> The "extern" makes it much easier to pick out at a glance.

Really? Grouping function prototypes within the header file is much more 
helpful for spotting them.

Regards,
Arend

> Please standardise on there _being_ externs if you must do this.
>
> It's gratuitous change anyway and not worth the churn.
>
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


