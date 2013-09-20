Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3ITI2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 04:28:36 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33224 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3ITI2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:28:33 -0400
MIME-Version: 1.0
In-Reply-To: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
References: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
Date: Fri, 20 Sep 2013 10:28:32 +0200
Message-ID: <CACRpkdZz1VwVoEyO-nntKDx185oBO0xOs0kaozJ_6W0xN-2c9w@mail.gmail.com>
Subject: Re: [RFC 0/5] New descriptor-based GPIO interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 1:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Another point that definitely needs more attention is the documentation. I am
> not sure whether the new interface should be described as a couple of sections
> in the existing GPIO documentation (the current approach) or as a new
> documentation file of its own.

The right way to do this would be to list the new way in the gpio.txt document,
then mark the old methods as deprecated.

Yours,
Linus Walleij
