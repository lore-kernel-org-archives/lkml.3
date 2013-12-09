Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3LIKKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:10:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab3LIKKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:10:06 -0500
Message-ID: <52A596DB.7040001@redhat.com>
Date: Mon, 09 Dec 2013 11:09:31 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev <netdev@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [linux-sunxi] Re: [PATCH 01/10] net: stmmac: Enable stmmac main
 clock when probing hardware
References: <1386350983-13281-1-git-send-email-wens@csie.org> <1386350983-13281-2-git-send-email-wens@csie.org> <20131207103335.GL24519@lukather> <CAGb2v65YOSq_BMWSzSHX8w_hbo+0vwquBT2pnLuwNVZkWRfLvA@mail.gmail.com>
In-Reply-To: <CAGb2v65YOSq_BMWSzSHX8w_hbo+0vwquBT2pnLuwNVZkWRfLvA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen-Yu,

It seems this patch is not enough, gmac won't work for me
with this patchset (*), unless I boot with an uboot which
also has the gmac patches.

Regards,

Hans


*) see my sunxi-test tree where I've dropped your
old version and added this version.
