Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3AXIc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:32:56 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:56388 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3AXIcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:32:51 -0500
MIME-Version: 1.0
In-Reply-To: <b2122295-0a35-4aba-90f3-8306b92af78b@email.android.com>
References: <1359001345-3446-1-git-send-email-airlied@gmail.com>
	<b2122295-0a35-4aba-90f3-8306b92af78b@email.android.com>
Date: Thu, 24 Jan 2013 18:32:50 +1000
Message-ID: <CAPM=9tzqfDb7wtwRbDcYYcoB_HBLWksP8NYggsfj_GcNu=CY-A@mail.gmail.com>
Subject: Re: [PATCH] vgacon/vt: clear buffer attributes when we load a 512
 character font
From: Dave Airlie <airlied@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 3:20 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> We should clear this bit presumably on switching either from or to 512-char mode, since the bit doesn't really make sense either way.

Yeah the only problem going from 512-char is that chars above 256 will
morph into garbage chars below 256, like ctrl chars, I don't really
want to face into doing some sort of safe translation out of 512-char
mode, from reading around the net, 512 char mode doesn't seem all that
brilliantly useful.

Dave.
