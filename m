Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab3LQSmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:42:55 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:55805 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab3LQSmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:42:52 -0500
Message-ID: <52B0A93E.7090503@cogentembedded.com>
Date: Tue, 17 Dec 2013 22:42:54 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Josh Triplett <josh@joshtriplett.org>
CC: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers: ide: Include appropriate header file in
 ide-cd_verbose.c
References: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com> <20131217111920.GA30592@pd.tnic> <20131217164403.GD1062@leaf> <20131217175451.GI30592@pd.tnic>
In-Reply-To: <20131217175451.GI30592@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/17/2013 08:54 PM, Borislav Petkov wrote:

>> The two proposed patches here are extremely low risk, don't actually
>> change the compiled code in any way like some of those did, and fix
>> real compiler warnings.

> Considering the fact that IDE is about to be deleted (unless something
> embedded still wants it which I hardly doubt

    You're right in your doubting: there are quite a lot of drivers used by 
embedded platforms that nobody has bothered to convert to libata thus far.

MBR, Sergei

