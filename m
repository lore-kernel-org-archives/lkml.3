Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760407AbaEMJoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:44:21 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:44968 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577AbaEMJoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:44:17 -0400
MIME-Version: 1.0
In-Reply-To: <e7a900f5996edb3588e0b2caf6b96ec3@statler.emutex.com>
References: <e7a900f5996edb3588e0b2caf6b96ec3@statler.emutex.com>
Date: Tue, 13 May 2014 11:44:16 +0200
Message-ID: <CACRpkdYhEdjd7P8Wz2yC-hDvQ015Aq9EzUEKE+dqf8JXDYFpRA@mail.gmail.com>
Subject: Re: [PATCH] gpio: generic: add request function pointer
From: Linus Walleij <linus.walleij@linaro.org>
To: Anthony Fee <anthony.fee@emutex.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 7:35 PM, Anthony Fee <anthony.fee@emutex.com> wrote:

> gpiolib will require all gpio drivers to expicitly set the request function
> pointer

Yeah send a plaintext version so I can apply it ;-)

Yours,
Linus Walleij
