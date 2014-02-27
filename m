Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaB0Nim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:38:42 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44963 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753303AbaB0Nii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:38:38 -0500
Date: Thu, 27 Feb 2014 10:38:32 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 00/10] pinctrl: mvebu: remove hard-coded addresses from
 Dove pinctrl
Message-ID: <20140227133831.GA28443@localhost>
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140224181023.GA1010@titan.lakedaemon.net>
 <CACRpkdZ+YGTyDj6i8c198MdRtz3GY-YBmVO9LysPCcmT4EC0cg@mail.gmail.com>
 <20140225151656.GI1010@titan.lakedaemon.net>
 <530CB725.5070904@gmail.com>
 <20140225154347.GJ1010@titan.lakedaemon.net>
 <530CEDB7.2070103@gmail.com>
 <20140225200447.GA1872@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140225200447.GA1872@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 03:04:47PM -0500, Jason Cooper wrote:
> On Tue, Feb 25, 2014 at 08:23:35PM +0100, Sebastian Hesselbarth wrote:
> > [Cooked down Cc list to relevant people and added Ezequiel who agreed
> > to test on Armada 375/38x.]
> > 
[..]
> 
> If you can drop the dtsi changes (I have them in mvebu/dt), and fix the
> whitespace change, then we can merge them as is.
> 

Tested for-next on Armada 375 and Armada 385 development boards. The
pinctrl debugfs looks correct.

I've been using for-next for a couple days now, without issues.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
