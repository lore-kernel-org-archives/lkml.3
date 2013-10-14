Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab3JNHIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 03:08:14 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:38916 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab3JNHIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 03:08:12 -0400
MIME-Version: 1.0
In-Reply-To: <1381706847-32762-1-git-send-email-roel.kluin@gmail.com>
References: <1381706847-32762-1-git-send-email-roel.kluin@gmail.com>
Date: Mon, 14 Oct 2013 09:08:11 +0200
Message-ID: <CACRpkdb8ibOm61D_iGkOkbas1475n4k5jptnRH7VFk=9+pipHQ@mail.gmail.com>
Subject: Re: [PATCH] unset twsi option3 for gconfig as well
From: Linus Walleij <linus.walleij@linaro.org>
To: Roel Kluin <roel.kluin@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please include Thomas & Sebastian on the To: line when posting
patches to this driver.

On Mon, Oct 14, 2013 at 1:27 AM, Roel Kluin <roel.kluin@gmail.com> wrote:

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

When you don't write a commit message I have no chance to
classify this patch.

- Is this a serious regression?

- Is this something that does not affect anybody, just a cleanup?

Please consult the following document:
Documentation/SubmittingPatches

Yours,
Linus Walleij
