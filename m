Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab3AQRDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:03:45 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:36153 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab3AQRDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:03:42 -0500
MIME-Version: 1.0
In-Reply-To: <20130116.221108.1062607586895392221.davem@davemloft.net>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
	<1358391258-1771-6-git-send-email-keescook@chromium.org>
	<20130116.221108.1062607586895392221.davem@davemloft.net>
Date: Thu, 17 Jan 2013 09:03:40 -0800
X-Google-Sender-Auth: yCqftMccmA3CIVQw8IRXR6l7AY0
Message-ID: <CAGXu5jJtkeOyjbUFtcycRAtFyykjLCUZ8s0ePM527SoNj_hkag@mail.gmail.com>
Subject: Re: [PATCH 05/86] drivers/net/ethernet/seeq: remove depends on CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: David Miller <davem@davemloft.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 7:11 PM, David Miller <davem@davemloft.net> wrote:
> Partially CC:'ing a mailing list for a subset of patches, without also
> CC:'ing that list on your openning "00/xxx" email explaing what you're
> doing and why is kind of pointless.

Hm? 0/86 got sent to lkml: https://lkml.org/lkml/2013/1/16/845

If you mean I didn't CC each of the people on the 0/86 email, yeah,
that was intentional since it's a long list of people and lkml tends
to drop emails with giant CC lists. I figured this was the sanest of
the various sub-optional solutions.

-Kees

--
Kees Cook
Chrome OS Security
