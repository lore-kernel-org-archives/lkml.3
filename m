Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab3E2Qjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:39:51 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:47806 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315Ab3E2Qjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:39:41 -0400
MIME-Version: 1.0
In-Reply-To: <1369661455-17839-2-git-send-email-gabriel.fernandez.st@gmail.com>
References: <1369661455-17839-1-git-send-email-gabriel.fernandez.st@gmail.com>
	<1369661455-17839-2-git-send-email-gabriel.fernandez.st@gmail.com>
Date: Wed, 29 May 2013 18:39:39 +0200
Message-ID: <CACRpkdZpMmmP7k5jTdaq_sX-HwS-R0fgEQ9oGkwGRLvC8kfoRw@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: ux500: use #include syntax to include *.dtsi.
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

On Mon, May 27, 2013 at 3:30 PM, Gabriel Fernandez
<gabriel.fernandez.st@gmail.com> wrote:

> From: Gabriel Fernandez <gabriel.fernandez@st.com>
>
> This patch prepares the use of '#define' into dts files.
>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>

Applied to my ux500-devicetree branch with Lee's ACK.

Yours,
Linus Walleij
