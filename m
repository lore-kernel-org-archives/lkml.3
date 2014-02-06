Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbaBFJVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 04:21:47 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:45665 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbaBFJVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 04:21:40 -0500
MIME-Version: 1.0
In-Reply-To: <52F149F4.6040105@broadcom.com>
References: <1391503770.19947.0.camel@phoenix>
	<52F149F4.6040105@broadcom.com>
Date: Thu, 6 Feb 2014 10:21:40 +0100
Message-ID: <CACRpkdY4rQC30idfYP0bJHeHL-OMbH=oSNaKf8pBfUP1f+sYBg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: capri: Make capri_pinctrl_probe static
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Daudt <bcm@fixthebug.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 9:13 PM, Sherman Yin <syin@broadcom.com> wrote:
> On 14-02-04 12:49 AM, Axel Lin wrote:
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>>
> Note that this will collide with the capri->bcm281xx renaming patches.
>
> Linus, Christian, are those patches going in soon?

I have ACKed it, expecting it to be funneled through ARM SoC.

Yours,
Linus Walleij
