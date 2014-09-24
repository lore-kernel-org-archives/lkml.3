Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaIXMh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:37:26 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38794 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaIXMhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:37:24 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 24 Sep 2014 14:34:51 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Johan Hovold <johan@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mfd: viperboard: allocate I/O buffer separately
Message-ID: <20140924123451.GA18804@localhost>
References: <1411414759-7056-1-git-send-email-octavian.purdila@intel.com>
 <1411414759-7056-2-git-send-email-octavian.purdila@intel.com>
 <20140924101206.GD19999@lee--X1>
 <20140924102853.GA17019@localhost>
 <20140924120002.GA32069@lee--X1>
 <20140924122658.GD17019@localhost>
 <CAE1zotLx-mB=rejxA9JwtWRwdYWinC82AXwtsczgQXFOSLMdrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotLx-mB=rejxA9JwtWRwdYWinC82AXwtsczgQXFOSLMdrA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:34:08PM +0300, Octavian Purdila wrote:

> I can follow-up with a v3 3 patch series: first for the fix, second
> for the OOM & error path cleanup, third for devm conversion.

I'd include the error-path clean up bit in the devres conversion as that
is what it's really all about.

Johan
