Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3GHWjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 18:39:09 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:60325 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3GHWjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 18:39:06 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <Cheiny@synaptics.com>
Cc: Balint Czobor <czoborbalint@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] drivers: input: touchscreen: Initial support for SYNAPTICS_I2C_RMI touchscreen
Date: Mon, 08 Jul 2013 15:39:02 -0700
Message-ID: <3502283.ihV8RhfYF2@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.10.4 (Linux/3.9.5-201.fc18.x86_64; KDE/4.10.4; x86_64; ; )
In-Reply-To: <BFABBC009FBA1C43B207B15FD485ABD92FDEB5DC@usw-mail3.synaptics-inc.local>
References: <1373271947-8393-1-git-send-email-czoborbalint@gmail.com> <51DB3B13.7070805@synaptics.com> <BFABBC009FBA1C43B207B15FD485ABD92FDEB5DC@usw-mail3.synaptics-inc.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 08, 2013 10:21:16 PM Christopher Heiny wrote:
> On 07/08/2013 01:25 AM, Balint Czobor wrote:
> > Add initial support for Synaptics RMI over I2C based touchscreens.
> 
> This is pretty old code - it looks like a modification of patches we
> submitted last year.  Is there some reason you're not basing it off the
> latest checkins in synaptics-rmi4 branch of  Dmitry's input tree?

That branch is fairly old as well, I believe you have much never
version on Github?

-- 
Dmitry
