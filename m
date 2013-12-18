Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3LRRfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:35:32 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:44155 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3LRRfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:35:31 -0500
Message-ID: <52B1EAF6.6080905@cogentembedded.com>
Date: Wed, 18 Dec 2013 21:35:34 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Josh Triplett <josh@joshtriplett.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers: ide: Include appropriate header file in
 ide-cd_verbose.c
References: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com> <20131217111920.GA30592@pd.tnic> <20131217164403.GD1062@leaf> <20131217175451.GI30592@pd.tnic> <52B0A93E.7090503@cogentembedded.com> <20131217190610.GJ30592@pd.tnic>
In-Reply-To: <20131217190610.GJ30592@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 10:06 PM, Borislav Petkov wrote:

>> You're right in your doubting: there are quite a lot of drivers used
>> by embedded platforms that nobody has bothered to convert to libata
>> thus far.

> Hold on, what does that mean? IDE is back from the dead and used only
> for embedded stuff?

    Like jazz, IDE "is not dead, it just smells funny".

> Or we force people to convert drivers to libata by *deleting* ide?

    I hope not. To me, it would be a shame e.g. to delete more or less 
well-designed IDE taskfile interface to the ad-hockery that libata has in its 
place...

> :-)

WBR, Sergei

