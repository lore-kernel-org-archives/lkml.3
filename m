Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaABMxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:53:05 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:57567 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaABMxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:53:03 -0500
MIME-Version: 1.0
In-Reply-To: <1378889173-7437-1-git-send-email-jose.goncalves@inov.pt>
References: <1378889173-7437-1-git-send-email-jose.goncalves@inov.pt>
Date: Thu, 2 Jan 2014 13:53:02 +0100
Message-ID: <CACRpkdY+aLA6OG3jjgwtLoH=O-SS-W_A5Ps9WZY70ogQN2RySg@mail.gmail.com>
Subject: Re: [PATCH] ARM: S3C24XX: Fix configuration of gpio port sizes on S3C24XX.
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 10:46 AM, José Miguel Gonçalves
<jose.goncalves@inov.pt> wrote:

> Some GPIO line limits are incorrectly set which, for instance,
> does not allow nRTS1 (GPH11) configuration on a S3C2416 chip.
>
> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>

Patch applied with Kukjin's ACK and Heiko's review tag.

Yours,
Linus Walleij
