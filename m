Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaKGMOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:14:09 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:49426 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaKGMOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:14:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Griffin <peter.griffin@linaro.org>, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH 12/13] ARM: STi: DT: STiH410: Add STiH410 SoC clock support.
Date: Fri, 07 Nov 2014 13:13:36 +0100
Message-ID: <88469624.TsXJ3Gpfe2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415361475-6218-13-git-send-email-peter.griffin@linaro.org>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org> <1415361475-6218-13-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:F9K5o9RTxFwiX7jbbhlBdLkAL4gzZTESYbTUjudoKjJ
 dBB9yoPL+ggvRHBffpxgUMp2Dy1ptzcn3tJJILKDnUS7RPTxww
 3GyKS8h2nXc4zqKPvCLfJNYNuVxVEPMYdPVKsaVBwnM1JYW1P9
 aeS2DW82pB36BtqMfoay4AmB2uYLnpB7Dd6KLT5Blr5xtzm2Sl
 /xWizuHoX1ZwRxb3ZV1qgpiCq/JgGK+zchtVcYy3i/FxcqkEgJ
 pqXwVrPwCaoZsN07EtIvQh8xQQqVvLuL9e64YOd14S1fVUe59N
 cBmWaOmAVGpVf7Mw4pINFd3sXHptWh7slgSu4AniXqHBB81UaO
 mwB3UO5XomIvwhCTP4mo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2014 11:57:54 Peter Griffin wrote:
> +
> +       soc {
> +
> +               ohci0: usb@9a03c00 {
> +                       status = "okay";
> +               };
> +
> +               ehci0: usb@9a03e00 {
> +                       status = "okay";
> +               };
> +
> +               ohci1: usb@9a83c00 {
> +                       status = "okay";
> +               };
> +
> +               ehci1: usb@9a83e00 {
> +                       status = "okay";
> +               };
> +       };
> +};
> 

These seem to refer to an existing device in the base dtsi file. Just put the label
in the shared file and remove the exact names here. Alternatively, drop the labels
you don't use.

	Arnd
