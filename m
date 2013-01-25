Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3AYCWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:22:42 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:55396 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab3AYCWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:22:25 -0500
MIME-Version: 1.0
In-Reply-To: <1ef10934-f81f-4a4b-b4a9-4d499e9721bc@email.android.com>
References: <1359001345-3446-1-git-send-email-airlied@gmail.com>
	<b2122295-0a35-4aba-90f3-8306b92af78b@email.android.com>
	<CAPM=9tzqfDb7wtwRbDcYYcoB_HBLWksP8NYggsfj_GcNu=CY-A@mail.gmail.com>
	<1ef10934-f81f-4a4b-b4a9-4d499e9721bc@email.android.com>
Date: Fri, 25 Jan 2013 12:22:24 +1000
Message-ID: <CAPM=9tyfxWBrqJM64B_VV0+KispQBSixVzdmhFocxmt9WNYEwg@mail.gmail.com>
Subject: Re: [PATCH] vgacon/vt: clear buffer attributes when we load a 512
 character font
From: Dave Airlie <airlied@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 10:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> The characters will morph anyway, it is just a matter off having them randomly scream with the intensity bit.
>
> 512-character mode is definitely useful... we get much wider language coverage with 512 than with 256, which is why most distros use a 512 console font.

Yeah really use a graphics console :-)

But I've sent a v2 patch that should clear the attribute space going
both directions.

Dave.
