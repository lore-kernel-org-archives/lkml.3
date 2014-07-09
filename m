Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbaGIPYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:24:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48989 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932591AbaGIPYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:24:52 -0400
Date: Wed, 9 Jul 2014 17:24:46 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Tejun Heo <tj@kernel.org>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, kishon@ti.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v9 3/7] ata: libahci: allow to use multiple PHYs
Message-ID: <20140709152446.GN3113@piout.net>
References: <1404728173-20263-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404728173-20263-4-git-send-email-antoine.tenart@free-electrons.com>
 <20140708134000.GC4979@htj.dyndns.org>
 <20140708170353.GA16148@kwain>
 <20140708171817.GH4979@htj.dyndns.org>
 <20140708174900.GC16148@kwain>
 <20140708214010.GI4979@htj.dyndns.org>
 <20140709082331.GA4510@kwain>
 <20140709135910.GA11193@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709135910.GA11193@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/07/2014 at 09:59:10 -0400, Tejun Heo wrote :
> Heh, I get that but, at the same time, this is the point where you're
> most motivated to actually work on it.  :)
> 

Or, starting that kind of review after 9 revisions, especially so close
to the end of the development cycle is discouraging enough and will
probably be used as an example of why we still have so many evil vendor
trees.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
