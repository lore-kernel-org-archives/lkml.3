Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3LGCOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 21:14:11 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:47714 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab3LGCOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 21:14:09 -0500
MIME-Version: 1.0
In-Reply-To: <20131206.162633.125107323851595113.davem@davemloft.net>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-4-git-send-email-wens@csie.org> <20131206.162633.125107323851595113.davem@davemloft.net>
From: Chen-Yu Tsai <wens@csie.org>
Date: Sat, 7 Dec 2013 10:13:44 +0800
X-Google-Sender-Auth: X-H9VNK_fl1LgPQBKZvaztJSAr4
Message-ID: <CAGb2v64eeq0v+nZ0gNOVTvWbEuk52DOX-aX0K=jO6tvSun8uCQ@mail.gmail.com>
Subject: Re: [PATCH 03/10] net: stmmac: Use platform data tied with compatible strings
To: David Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        "rob.herring" <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        "maxime.ripard" <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 7, 2013 at 5:26 AM, David Miller <davem@davemloft.net> wrote:
> From: Chen-Yu Tsai <wens@csie.org>
> Date: Sat,  7 Dec 2013 01:29:36 +0800
>
>> +     device = of_match_device(stmmac_dt_ids, &pdev->dev);
>> +     if (!device)
>> +             return -ENODEV;
>> +
>> +     if (device->data)
>> +         memcpy(plat, device->data, sizeof(*plat));
>> +
>
> Don't invent your own indentation using spaces, this memcpy()
> call is not indented properly, it should be two TABs.

Noted. Will fix.
