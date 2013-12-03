Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3LCMof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:44:35 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41393 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268Ab3LCMoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:44:34 -0500
X-Sasl-enc: 5wUoGhPjCvJ35AjKk+PSBh4dfkp+qy/gi927l088CQNZ 1386074673
Message-ID: <529DD22F.3040102@iki.fi>
Date: Tue, 03 Dec 2013 14:44:31 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joonsoo Kim <js1304@gmail.com>
CC: Meelis Roos <mroos@linux.ee>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: Slab BUG with DEBUG_* options
References: <alpine.SOC.1.00.1311300125490.6363@math.ut.ee>	<529DC632.9010107@iki.fi> <CAAmzW4N=2--OuOFVEME3FJa7uFCkVEYJp=9DbSBVOPjiXnLxcg@mail.gmail.com>
In-Reply-To: <CAAmzW4N=2--OuOFVEME3FJa7uFCkVEYJp=9DbSBVOPjiXnLxcg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 02:25 PM, Joonsoo Kim wrote:
> No. He report that BUG() is triggered on v3.11-rc2 and v3.12.
> And my recent change is merged into v3.13-rc1 as you know. :)

Hah, I guess my eyesight isn't what it used to be, I could have sworn it 
said v3.13-rc2... Thanks anyway, Joonsoo!

                             Pekka
