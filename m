Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbaCSWx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:53:27 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:39922 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaCSWxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:53:25 -0400
Message-ID: <532A2DEF.9040101@cogentembedded.com>
Date: Thu, 20 Mar 2014 02:53:19 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2a RESEND 2/2] of_mdio: Allow the DT to specify the phy
 ID and avoid autoprobing
References: <1394658311-17769-1-git-send-email-jgunthorpe@obsidianresearch.com> <1394658311-17769-2-git-send-email-jgunthorpe@obsidianresearch.com> <CAL_Jsq+qdbiwXErkZv1zZ9rphYY9NP6zHmmjw313tMvGeSTODg@mail.gmail.com> <20140319221404.GA1154@obsidianresearch.com> <532A262B.803@cogentembedded.com> <20140319223633.GC1154@obsidianresearch.com>
In-Reply-To: <20140319223633.GC1154@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 01:36 AM, Jason Gunthorpe wrote:

>>>>     The preferred multi-line comment style is:

>>>> /*
>>>>   * bla
>>>>   * bla
>>>>   */

>>> Sergei, the entire file use the 'net' multi-line commenting style, and
>>> I have maintined that consistency with the new code.

>>     No, you haven't followed the networking style. It is:

>> /* bla
>>   * bla
>>   */

>> while your comment used:

>> /* bla
>>   * bla */

> Oh Ok - but the latter is the used by the majority of pre-existing
> comments..

> I thought the convention on stuff like this was to stick with the
> existing style?

    Hardly so when there's preferred one, described in CodingStyle.

> Do you think it is worth a v4? If so, which style is appropriate?
> There is one other pre-existing comment that uses net.

    Well, use the net style then. I don't see significant difference between 
it and the "default" preferred style.

> Regards,
> Jason

WBR, Sergei

