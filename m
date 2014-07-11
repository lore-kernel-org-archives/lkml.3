Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaGLMPt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 08:15:49 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:50831 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaGLMPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 08:15:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCHv8 1/2] mailbox: rename pl320-ipc specific mailbox.h
Date: Fri, 11 Jul 2014 19:12:14 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ks.giri@samsung.com, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, robh+dt@kernel.org, pawel.moll@arm.com,
        courtney.cavin@sonymobile.com, mporter@linaro.org,
        slapdau@yahoo.com.au, lftan.linux@gmail.com, loic.pallardy@st.com,
        s-anna@ti.com, ashwin.chaugule@linaro.org, bjorn@kryo.se,
        patches@linaro.org, Mollie.Wu@tw.fujitsu.com,
        t.takinishi@jp.fujitsu.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org> <1405071252-14630-1-git-send-email-jaswinder.singh@linaro.org>
In-Reply-To: <1405071252-14630-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201407111912.14538.arnd@arndb.de>
X-Provags-ID: V02:K0:JvG8OEoTw1Vw2U7cHFQyF0Yn69D9vtqTZ7vL9CW+VrM
 q+xG/fpBdRL9fxJPV0kOje4Qx8ym/DeQHnin1UQDm+lOKXzN12
 W22s6DJaeYW2DESZm3i2HGP5NEcVciOP1eFdp5V2o0mxpEqBa4
 8qZqI7rRsXP7dky2VW1Rxw0g9RpKBiKMsFKfy1va7PoZOlKj4p
 9c9owD9gtSs2bUTI3dPZx0TRAvNeOeuf/bxWnLT4WNb+O6tXo5
 iO7H7fO3TM5YNJWc3LU2yjXs7c2WoCHJis6nIiNQJVQ3tAMWv6
 SSOFZnac7QbFWBeoRAcdS7KsvJ8sgLRVZpQJzEKsK8vH+m1N2+
 zQAhHaThbhfjYELM603Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2014, Jassi Brar wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> The patch 30058677 "ARM / highbank: add support for pl320 IPC"
> added a pl320 IPC specific header file as a generic mailbox.h.
> This file has been renamed appropriately to allow the
> introduction of the generic mailbox API framework.
> 
> Acked-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
