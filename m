Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3AMMYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 07:24:48 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:55366 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab3AMMYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 07:24:46 -0500
Message-ID: <50F2A77E.1090900@ahsoftware.de>
Date: Sun, 13 Jan 2013 13:24:30 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Bernie Thompson <bernie@plugable.com>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Dave Airlie <airlied@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] fb: udlfb: fix hang at disconnect
References: <1357996822-13072-1-git-send-email-holler@ahsoftware.de> <CAF1V4O8UUgWB1XbS=3EsirBjhP9Lp7JQ8XK8MQxbe3ZkH8pd3Q@mail.gmail.com> <50F2A310.5010006@ahsoftware.de>
In-Reply-To: <50F2A310.5010006@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.01.2013 13:05, schrieb Alexander Holler:
> Am 12.01.2013 23:22, schrieb Bernie Thompson:

> I didn't test it extensively, but without the patch the driver isn't
> usable here. Maybe my previous patch which moves damages to a workqueue

To add some more explanations, I'm currently only testing it with a 
statically linked udlfb (for fbcon) as that is what I'm mainly using the 
device for (with otherwise headless boxes). When udlfb is a module, I 
don't see those "schedule while atomic" messages (I don't know why), but 
having a console only after the modules got loaded isn't always an option.

Regards,

Alexander
