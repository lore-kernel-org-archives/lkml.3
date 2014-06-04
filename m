Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaFDNge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:36:34 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65180 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbaFDNgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:36:31 -0400
Message-ID: <538F20D6.7030207@gmail.com>
Date: Wed, 04 Jun 2014 15:36:22 +0200
From: =?ISO-8859-1?Q?Pascal_H=FCrst?= <pascal.huerst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Russ Dill <Russ.Dill@ti.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, mans@mansr.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC PATCH 00/11] Embeddable Position Independent Executable
References: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com> <201310241009.12597.heiko@sntech.de> <1441820.DP5PYDOd2T@phil>
In-Reply-To: <1441820.DP5PYDOd2T@phil>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ru

On 22.04.2014 10:15, Heiko Stübner wrote:
> Hi Russ,
>
> Am Donnerstag, 24. Oktober 2013, 10:09:12 schrieb Heiko Stübner:
>> Am Dienstag, 17. September 2013, 14:43:26 schrieb Russ Dill:
>>> This patch adds support for and demonstrates the usage of an embedded
>>> position independent executable (PIE). The goal is to allow the use of C
>>> code in situations where carefully written position independent assembly
>>> was previously required.
>>
>> As suggested yesterday evening by Kevin Hilman, just adding my 2ct of
>> support.
>>
>> This series looks exactly like the foundation I'll need at some point in the
>> (probably still distant) future to handle suspend on my Rockchip platform -
>> where like in your example stuff like putting the ram into selfrefresh has
>> to be done by the os.
>
> just as it came up recently again for me and I couldn't find any newer version,
> ist this series still on the table?

We have to maintain quite some patches, to keep pm working for our 
project, so we're interested to get this mainline, too. Is someone 
taking care of these issues? Or is there something i can do to help 
getting this done?

regards
pascal
