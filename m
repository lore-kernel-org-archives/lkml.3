Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3JUOUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:20:40 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:52967 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3JUOUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:20:35 -0400
MIME-Version: 1.0
In-Reply-To: <20131021065804.GX3521@intel.com>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
	<1382326010-4554-3-git-send-email-bleung@chromium.org>
	<20131021065804.GX3521@intel.com>
Date: Mon, 21 Oct 2013 07:20:33 -0700
X-Google-Sender-Auth: UQucmANVi14iFG1GkXpeP9KjYWo
Message-ID: <CANLzEksGqD30Cefh3r2urH-ToxWzkxAnTJZiY07yX2Py58FQPw@mail.gmail.com>
Subject: Re: [PATCH 2/2] i2c-designware-pci: Index Haswell ULT bus names from 0
From: Benson Leung <bleung@chromium.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: wsa@the-dreams.de, khali@linux-fr.org, andriy.shevchenko@linux.intel.com,
        jacmet@sunsite.dk, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Duncan Laurie <dlaurie@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 11:58 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> Is there any real value in having names like "i2c-designware-pci-0"
> available? I would just drop the whole naming dance instead...

I'd like some way of distinguishing between the two busses by name. It
seems sensible to name them 0 and 1 since that's how they are referred
to on schematics.

In the chromeos_laptop driver, I do by-name matching of i2c busses to
find busses and instantiate devices, so there is value to have each
named something predictable.

-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
