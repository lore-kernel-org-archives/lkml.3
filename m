Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbbALHZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 02:25:07 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:44649 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbALHZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 02:25:05 -0500
MIME-Version: 1.0
In-Reply-To: <20150112160258.16b8ba3d@canb.auug.org.au>
References: <20150112160258.16b8ba3d@canb.auug.org.au>
Date: Mon, 12 Jan 2015 08:25:04 +0100
Message-ID: <CACRpkdabseH0joZLGraEZpRKnAYCsB7krtjkG8m0sfgwaowc4w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the pinctrl tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        =?UTF-8?B?QW5kcmVhcyBGw4PCpHJiZXI=?= <afaerber@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 6:02 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> After merging the pinctrl tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

Fixed already, hopefully. (Atleast the autobuilders are happy.)

Yours,
Linus Walleij
