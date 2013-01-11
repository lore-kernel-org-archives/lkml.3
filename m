Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3AKJWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:22:04 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57853 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3AKJWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:22:01 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-ac-50efd9b7a997
Message-id: <50EFD9B3.7090503@samsung.com>
Date: Fri, 11 Jan 2013 10:21:55 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, sylvester.nawrocki@gmail.com,
        t.figa@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com, l.majewski@samsung.com,
        kyungmin.park@samsung.com, grant.likely@secretlab.ca, heiko@sntech.de,
        dianders@chromium.org, p.paneri@samsung.com
Subject: Re: [PATCH] usb: phy: samsung: Add support to set pmu isolation
References: <1357891738-26259-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1357891738-26259-1-git-send-email-gautam.vivek@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t/xa7rbb74PMLi/hNXi8q45bBYzzu9j
	sli0rJXZgdnj8ya5AMYoLpuU1JzMstQifbsEroxXrQ+ZCk4wVdy9dIKtgbGPqYuRk0NCwETi
	zLcFrBC2mMSFe+vZuhi5OIQEljJKvF84DywhJPCJUaKpIw7E5hXQkrjS8IsNxGYRUJVYcucw
	I4jNJmAo0Xu0D8wWFQiQWLzkHDtEvaDEj8n3WEBsEQFtie1zJ7GCLGAWWMwisXZOC9gVwgIe
	EhevvIRa5iGxpmMRWJxTwFPi/8/jYDazgI7E/tZpbBC2vMTmNW+ZJzAKzEKyYxaSsllIyhYw
	Mq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAnLLzsYFx+zOsQowMGoxMOroP4+QIg1say4
	MvcQowQHs5IIb00tUIg3JbGyKrUoP76oNCe1+BAjEwenVAOjgY9MoYdBnOLtXq1WrksCmTfP
	/71q9DtP0FTq+0KjjJ6Sfd9YEv4JXgzaObHlRzLL3dPJNn2ZU9p/iV9lTs5b8zDpTUVGtmNk
	rsHh2En3DR6FcwRosn20UH3btiraw1tpu7Tpz6IZJaJlexbPuL462OfSKb3OHSfkMtVf3Tt4
	cG2WjtJMgwolluKMREMt5qLiRAD5+lnrKQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 09:08 AM, Vivek Gautam wrote:
> Adding support to parse device node data in order to get
> required properties to set pmu isolation for usb-phy.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

Thanks for addressing my all comments,

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

