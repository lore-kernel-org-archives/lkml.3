Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaJOTzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:55:54 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:46811 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbaJOTzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:55:53 -0400
Message-ID: <543ED147.7090407@akamai.com>
Date: Wed, 15 Oct 2014 15:55:51 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Paolo Pisati <p.pisati@gmail.com>
CC: David Miller <davem@davemloft.net>, Laura Abbott <lauraa@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: arm: JUMP_LABEL and DEBUG_SET_MODULE_RONX should be mutually
 exclusive?
References: <20141015122102.GB4427@stinkpad> <CAGXu5jLEAjR+X0KnnipGH2gp569_PFp5DYyfgXU=Szxgk5EcpA@mail.gmail.com>
In-Reply-To: <CAGXu5jLEAjR+X0KnnipGH2gp569_PFp5DYyfgXU=Szxgk5EcpA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 11:34 AM, Kees Cook wrote:
> On Wed, Oct 15, 2014 at 5:21 AM, Paolo Pisati <p.pisati@gmail.com> wrote:
>> Hi,
>>
>> i keep hitting this with BRIDGE=m, JUMP_LABEL=y and DEBUG_SET_MODULE_RONX=y:
> I think my RO/NX patch series solves this. I sent a pull request, but
> I haven't seen any movement on it. :(
>

Please let me know if this doesn't fix it, I don't want to see JUMP_LABEL
disabled b/c DEBUG_SET_MODULE_RONX is set.

Thanks,

-Jason
