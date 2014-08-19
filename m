Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaHSReF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:34:05 -0400
Received: from sv1-2.x14.eu ([144.76.176.218]:50745 "EHLO sv1-2.x14.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbaHSReD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:34:03 -0400
Message-ID: <53F38A84.3070702@vipserv.org>
Date: Tue, 19 Aug 2014 19:33:56 +0200
From: Krzysztof Majzerowicz-Jaszcz <cristos@vipserv.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Joe Perches <joe@perches.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] drivers: net: ethernet: intel: e1000: e1000_ethertoo.c
 coding style fixes
References: <1408393263-18027-1-git-send-email-cristos@vipserv.org> <CAL3LdT7+5FFbP5Rf1MoY2GJ9cQ0LJnecQb66ZA2ofwD28vy1jw@mail.gmail.com>
In-Reply-To: <CAL3LdT7+5FFbP5Rf1MoY2GJ9cQ0LJnecQb66ZA2ofwD28vy1jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: cristos@vipserv.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/08/14 18:04, Jeff Kirsher wrote:
> On Mon, Aug 18, 2014 at 3:21 PM, Krzysztof Majzerowicz-Jaszcz
> <cristos@vipserv.org> wrote:
>> Fixed many errors/warnings and checks in e1000_ethtool.c reported by checkpatch.pl
>> Suggestions from Joe Perches and Alexander Duyck applied as well
>>
>> Signed-off-by: Krzysztof Majzerowicz-Jaszcz <cristos@vipserv.org>
>> ---
>>  drivers/net/ethernet/intel/e1000/e1000_ethtool.c | 155 ++++++++++++-----------
>>  1 file changed, 79 insertions(+), 76 deletions(-)
>>
> 
> Thanks Krzysztof, I will add your patch to my queue and I can fix up
> the patch title for you. :-)
>

Thank you :). Sorry for that patch title - I guess that 'first pancake is always spoiled'.
Nonetheless, that makes my first successful contribution to the kernel <yay> ;)
