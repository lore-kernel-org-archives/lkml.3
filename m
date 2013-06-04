Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab3FDI5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:57:53 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:58125 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3FDI5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:57:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAGo1xzDB-uGsMANghtqX-rX6GuhmHKo1Z=ywtC=TXfx6eM_ALQ@mail.gmail.com>
References: <1369834407-30762-1-git-send-email-gabriel.fernandez.st@gmail.com>
	<1369834407-30762-2-git-send-email-gabriel.fernandez.st@gmail.com>
	<20130529155018.GE3012@gmail.com>
	<CAGo1xzDB-uGsMANghtqX-rX6GuhmHKo1Z=ywtC=TXfx6eM_ALQ@mail.gmail.com>
Date: Tue, 4 Jun 2013 10:57:49 +0200
Message-ID: <CACRpkdbThH7LysDjrPcFjxg0sMDm1myTfmXkJnkY3QSS3F_GGQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: ux540: Add ccu8540-uib-v3 Device Tree Machine
From: Linus Walleij <linus.walleij@linaro.org>
To: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 3:20 PM, Gabriel Fernandez
<gabriel.fernandez.st@gmail.com> wrote:

[Lee]
>> Is it a new board, or just a UIB?
>
> For me it's a new board.
>
> ccu8540.dts is a board without uib.
> You can can plug on this board some different uibs.
> That's why, i created a ccu8540-uib-v3.dts board in which i included a
> common board ccu8540.dts

So that means that ccu8540.dts will boot the system even
without any UIB if I understand correctly. Anything that
pertains to the UIB should be in the UIB overlay.

> Another solution is to create one *.dtsi file with all uibs for
> ccu8540 and makes a dynamique detection.
> Linus, Lee  what do you think about that ?

I'm lost on this, dynamic detection would be done in the
boot loader, usually this just encodes one, static tree.

The first approach seems OK with me.

Yours,
Linus Walleij
