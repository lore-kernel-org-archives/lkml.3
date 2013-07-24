Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3GXUDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:03:50 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:49307 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3GXUDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:03:48 -0400
Message-ID: <1374696565.7397.1292.camel@haakon3.risingtidesystems.com>
Subject: Re: targetcli -fb now also Apache 2.0 licensed
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andy Grover <agrover@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Ritesh Raj Sarraf <rrs@debian.org>,
        targetcli-fb-devel@lists.fedorahosted.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 24 Jul 2013 13:09:25 -0700
In-Reply-To: <51EF73EF.1040305@redhat.com>
References: <51EF73EF.1040305@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 23:27 -0700, Andy Grover wrote:
> Hi Nick,
> 
> I just wanted to let you know that I finally received permission from 
> all contributors, and have matched RisingTide's relicensing of targetcli 
> and its dependencies to Apache 2.0, by relicensing the additional 
> contributions in the targetcli-fb branch under the same license.
> 
> I'm not quite sure the next steps are, except enjoying all our newly 
> non-viral source code, but much thanks for getting the ball rolling.
> 

Making this type of announcement without coordinating with us on a plan
for moving forward is pretty lame.  Especially considering that we've
kept asking you privately about how to work together to reconcile -fb
with upstream, and your response essentially boiled down to "What's in
it for me..?".

So if you really, really need an incentive to "do the right thing", how
about I start not accept kernel patches from you until you're ready to
drop -fb and start working with upstream for real..?

--nab

