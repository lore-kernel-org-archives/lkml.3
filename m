Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3EJS4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 14:56:14 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:63714 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3EJS4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 14:56:12 -0400
Message-ID: <518D42D3.3010709@cogentembedded.com>
Date: Fri, 10 May 2013 22:56:19 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH] IDE: bugfix of IDE PIO size calculation
References: <20130510184711.32151.70337.stgit@linux-yegoshin>
In-Reply-To: <20130510184711.32151.70337.stgit@linux-yegoshin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/10/2013 10:47 PM, Leonid Yegoshin wrote:

> IDE PIO calculates size wrong.
> Proven by test on MIPS Malta platform with multiple CPU types
> with bootparam flag "ide-core.nodma=0.0".
>
> It is still needed to test non-DMA IO.
>
> Change-Id: Id82c2bc5965d85960846db53d84846d9a05d75a3

    Please get rid of this line.

> Author: Leonid Yegoshin <yegoshin@mips.com>

     From: line at the start of message is used for that.

> Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
> (imported from commit 43cee988ce0aa8d2ca1eec014d25f014e95eefe6)
> (imported from commit d74805b8b12cada05df811e112eb7e3ec197d565)

     What are those two lines? Why are they here, in upstream patch?

WBR, Sergei

