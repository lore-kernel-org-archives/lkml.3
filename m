Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaFMUzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:55:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaFMUzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:55:45 -0400
Date: Fri, 13 Jun 2014 16:55:35 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input - wacom: remove phys field in struct wacom
Message-ID: <20140613205534.GB30355@mail.corp.redhat.com>
References: <1402691344-26196-1-git-send-email-benjamin.tissoires@redhat.com>
 <20140613203545.GA31651@core.coreip.homeip.net>
 <20140613204826.GA30355@mail.corp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140613204826.GA30355@mail.corp.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 13 2014 or thereabouts, Benjamin Tissoires wrote:
> On Jun 13 2014 or thereabouts, Dmitry Torokhov wrote:
> > On Fri, Jun 13, 2014 at 04:29:04PM -0400, Benjamin Tissoires wrote:
> > > This field is not used, remove it.
> > 
> > We must have lost the assignment, but it should be assigned to phys of
> > corresponding input device. 
> 
> hehe. Even in 2007, when the files moved under drivers/input/tablet,
> there is no mention of assigning input_dev->phys :)
> 
> I can send a patch to fix the other way around if you prefer (add
> input_dev->phys).
> 

Actually, I found the culprit:
$ git describe c5b7c7c395a34f12cdf246d66c1feeff2933d584
v2.6.14-21-gc5b7c7c
---> Thu Sep 15 02:01:47 2005

I should have wait one more year to fix it :)

No one complain about it for nearly 10 years, so I am not sure it will
help assigning the ->phys field of input_dev.

It's your call, Dmitry.

Cheers,
Benjamin
