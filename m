Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab3FEWCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:02:12 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55837 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab3FEWCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:02:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+RnqpvMkKo7vCdd2fCDoZi
Date: Wed, 5 Jun 2013 15:02:05 -0700
From: Tony Lindgren <tony@atomide.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        Walleij Linus <linus.walleij@linaro.org>, Sekhar Nori <nsekhar@ti.com>,
        grant.likely@linaro.org, Rob Herring <rob.herring@calxeda.com>,
        Linux Russell <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        prabhakar.csengg@gmail.com, peter.ujfalusi@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH 2/3] pinctrl: pinctrl-single: pin names for
 pinctrl-single.bits
Message-ID: <20130605220204.GF3331@atomide.com>
References: <1369145282-14419-1-git-send-email-prakash.pm@ti.com>
 <1369145282-14419-4-git-send-email-prakash.pm@ti.com>
 <CAN1soZx+xYJT24XZqoynFJj3wjTuq14S6dtpd=SFw5_iDWTiWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1soZx+xYJT24XZqoynFJj3wjTuq14S6dtpd=SFw5_iDWTiWw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Haojian Zhuang <haojian.zhuang@gmail.com> [130604 22:31]:
> On Tue, May 21, 2013 at 10:08 PM, Manjunathappa, Prakash
> <prakash.pm@ti.com> wrote:
> > Take care to name pin names as
> > register-offset.bit-pos-of-pin-in-register in case configuring multiple
> > pins in register.
> >
> > Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
> > ---
> 
> Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>

Acked-by: Tony Lindgren <tony@atomide.com>
