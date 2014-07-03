Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbaGCHZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:25:25 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:38765 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbaGCHZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:25:23 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.36.201]
In-Reply-To: <53B460B4.9010200@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
 <1398904476-26200-6-git-send-email-s-anna@ti.com> <CAK=WgbamDPN9EmKUu3+c3RbsQn1uhz5MGGvpWSSUJSUKyoH8Cw@mail.gmail.com>
 <53B460B4.9010200@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 3 Jul 2014 10:25:01 +0300
Message-ID: <CAK=WgbZL9XbMtHpsQz8zuo5mbqSUnQhtjDoWPi2M2mfVxjaFNw@mail.gmail.com>
Subject: Re: [PATCHv5 05/15] hwspinlock/omap: add support for dt nodes
To: Suman Anna <s-anna@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 10:42 PM, Suman Anna <s-anna@ti.com> wrote:
> Yeah, I did this since we only had 1 instance, and used the same value
> as used in the non-DT legacy code. Once I fold back Patch 8 that adds
> the hwlock-base-id property, this will be assigned by reading that property.

Sounds good, thanks!
