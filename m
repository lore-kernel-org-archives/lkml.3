Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaAFL0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:26:34 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:34968 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaAFL0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:26:32 -0500
MIME-Version: 1.0
In-Reply-To: <20140106104640.GK23772@lee--X1>
References: <1386329534-14186-1-git-send-email-k.kozlowski@samsung.com>
	<1386329534-14186-4-git-send-email-k.kozlowski@samsung.com>
	<20140106104640.GK23772@lee--X1>
Date: Mon, 6 Jan 2014 20:26:30 +0900
X-Google-Sender-Auth: -UjwMTcKTWSLn9OG0ec2qcLtoM4
Message-ID: <CAH9JG2Wcip=5SEmkRBn9KzWajFmn9mQzKma23vk8F67bp9-AkQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/3] mfd: max14577: Add device tree bindings document
From: Kyungmin Park <kmpark@infradead.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Anton Vorontsov <anton@enomsg.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>,
        Rob Landley <rob@landley.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 6, 2014 at 7:46 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> Add document describing device tree bindings for MAX14577 MFD driver.
>>
>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  Documentation/devicetree/bindings/mfd/max14577.txt |   65 ++++++++++++++++++++
>>  1 file changed, 65 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
>
> You still need a DT Ack before I can apply this.

Tomasz, can you ack it?

Thank you,
Kyungmin Park
