Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab3FXOfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:35:44 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:63139 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3FXOfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:35:43 -0400
MIME-Version: 1.0
In-Reply-To: <1371047735-14851-1-git-send-email-gabriel.fernandez.st@gmail.com>
References: <1371047735-14851-1-git-send-email-gabriel.fernandez.st@gmail.com>
Date: Mon, 24 Jun 2013 16:35:43 +0200
Message-ID: <CACRpkdZgXZC+b8yzpYjNPV4=YWSMFjMPtkw6jc68x+9CiAjTjw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: u8540: Add Pinctrl Device Tree settings for
 uart0, uart2
From: Linus Walleij <linus.walleij@linaro.org>
To: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 4:35 PM, Gabriel Fernandez
<gabriel.fernandez.st@gmail.com> wrote:

> From: Gabriel Fernandez <gabriel.fernandez@st.com>
>
> This patch adds pinctrl device tree settings for uart0 and uart2
> for ccu8540 board.
>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>

Patch applied to the ux500-devicetree branch in my tree, sorry for the delay!

> +++ b/include/dt-bindings/pinctrl/nomadik.h

I'll try to fix a patch using this for the old Nomadik as well.

Yours,
Linus Walleij
