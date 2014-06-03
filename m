Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaFCHHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:07:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbaFCHHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:07:35 -0400
Message-ID: <538D7430.2080200@redhat.com>
Date: Tue, 03 Jun 2014 09:07:28 +0200
From: Michal Privoznik <mprivozn@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, vfalico@redhat.com
CC: jiri@resnulli.us, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net-sysfs: Report link speed as signed integer
References: <06d53256e3bf2d0deedb16249082200500da3ee6.1401718809.git.mprivozn@redhat.com>	<20140602143557.GA2925@minipsycho.orion>	<20140602150150.GF6295@redhat.com> <20140602.111050.54996809312556969.davem@davemloft.net>
In-Reply-To: <20140602.111050.54996809312556969.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.06.2014 20:10, David Miller wrote:
> From: Veaceslav Falico <vfalico@redhat.com>
> Date: Mon, 2 Jun 2014 17:01:50 +0200
>
>> I wonder, though, if we should document it or just output "Unknown"
>> instead of -1.
>
> All of this discussion means that we can't change the format string
> without potentially breaking something out there interpreting the -1
> value, however it gets output now.

No, the discussion means reporting -1 as link speed is confusing.

>
> I think we just have to leave things as-is and document them in the
> sysfs ABI docs.

Well, that's rather unpleasant.

>
> I'm not applying this patch.
>

Michal
