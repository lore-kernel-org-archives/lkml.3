Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaANK1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:27:41 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:63322 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaANK1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:27:37 -0500
MIME-Version: 1.0
In-Reply-To: <52CD25FE.8010701@overkiz.com>
References: <1387463671-1164-1-git-send-email-b.brezillon@overkiz.com>
	<1387463671-1164-2-git-send-email-b.brezillon@overkiz.com>
	<CACRpkdb=atfrW+Wqbi17a1KhstS7XHkutuXsM24gL2VPEri_cw@mail.gmail.com>
	<52CD25FE.8010701@overkiz.com>
Date: Tue, 14 Jan 2014 11:27:36 +0100
Message-ID: <CACRpkdaEOyj-WcmR9e366O+qjLRZufo9732KUUB_OCXbER-YEQ@mail.gmail.com>
Subject: Re: [RFC PATCH] gpio: add GPIO hogging mechanism
From: Linus Walleij <linus.walleij@linaro.org>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Rob Landley <rob@landley.net>, Alexandre Courbot <gnurou@gmail.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 11:18 AM, boris brezillon
<b.brezillon@overkiz.com> wrote:

> Anyway, do you want me to rework the gpio hog as described below ?

If you feel you have time, drive and a proper usecase for testing it,
sure. I just want it to be driven my someone who *really* needs
that feature.

Yours,
Linus Walleij
