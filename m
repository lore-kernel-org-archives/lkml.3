Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaETTj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 15:39:26 -0400
Received: from host171.canaca.com ([67.55.55.225]:38673 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaETTjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 15:39:25 -0400
Message-ID: <8c45868c3cd4333d1098bdbc0fa83a2e.squirrel@mungewell.org>
In-Reply-To: <537B9FAE.9070602@logitech.com>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
    <1818063.tFLKhAd1oy@sigyn>
    <20140514180558.GB30089@core.coreip.homeip.net>
    <2965006.XKYHWj9YzJ@sigyn> <537B9FAE.9070602@logitech.com>
Date: Tue, 20 May 2014 15:39:19 -0400
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
From: simon@mungewell.org
To: "Roland Bosa" <rbosa@logitech.com>
Cc: =?iso-8859-1?Q?=22Michal_Mal=FD=22?= 
	<madcatxster@devoid-pointer.net>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, elias.vds@gmail.com, anssi.hannula@iki.fi,
        simon@mungewell.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Allow me to introduce myself. I'm Roland Bosa and I work for Logitech,
> more specifically the gaming group. I have been tasked to look into
> gaming device support for Linux and I just started following this list
> and studying the kernel code related to the Logitech Force Feedback
> devices. The 'ff-memless-next' module sounds tailor-made for our
> devices. Please let me know how I can help with its development.

Hello Roland,
Let me echo Michal's welcome.

As you will see from the 'ff-memless-next' driver we are looking to extend
force-feedback support to cover more than just ConstantForce support, and
hopefully bring Linux into scope for force-feedback of AAA game quality.

Mostly this has come from a small group of people reverse engineering the
Logitech wheels, which leads to the 'tailor-made' situation. But we'd like
the systems/interfaces to be device agnostic.

As you how you can help...? As Michal said having a contact at Logitech to
whom we can ask technical questions (off list) would probably be the
greatest help. This would clear up any assumptions we have made, and help
with decisions going forward.

It may also be the case that Logitech is working with studios/game
designers to improve controller performance. If any information can be
feed 'forward' to improve the Linux driver, that would be useful too.

Many thanks,
Simon Wood.

