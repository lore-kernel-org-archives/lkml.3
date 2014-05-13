Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaEMQ6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:58:12 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:58577 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaEMQ57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:57:59 -0400
Message-ID: <53724F10.8030607@elopez.com.ar>
Date: Tue, 13 May 2014 13:57:52 -0300
From: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rob Herring <robh@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 3/7] clk: sunxi: avoid double DT matching
References: <1399940993-1773-1-git-send-email-robherring2@gmail.com>	<1399940993-1773-4-git-send-email-robherring2@gmail.com> <CAL_JsqL0wWi0Pz6NirzEVWeHKqrRiGB6Q+9JYp6ew5KTeeY0dQ@mail.gmail.com>
In-Reply-To: <CAL_JsqL0wWi0Pz6NirzEVWeHKqrRiGB6Q+9JYp6ew5KTeeY0dQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

For 3/7 (with the mentioned fix) and 4/7 my Cubietruck still boots, so

Acked-by: Emilio López <emilio@elopez.com.ar>
Tested-by: Emilio López <emilio@elopez.com.ar>

El 13/05/14 12:12, Rob Herring escribió:
> On Mon, May 12, 2014 at 7:29 PM, Rob Herring <robherring2@gmail.com> wrote:
>> From: Rob Herring <robh@kernel.org>
>>
>> Use for_each_matching_node_and_match instead of for_each_matching_node plus
>> of_match_node to avoid searching the DT twice for each node.
>>
>> The sunxi DT scanning code should really be re-worked rather than have
>> its own private matching infrastructure. It is working around needing a
>> function pointer and a data pointer for each compatible match.
>>
>> Signed-off-by: Rob Herring <robh@kernel.org>
>> Cc: "Emilio López" <emilio@elopez.com.ar>
>> Cc: Mike Turquette <mturquette@linaro.org>
>> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>

Cheers,

Emilio
