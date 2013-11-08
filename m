Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab3KHTMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:12:15 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60883 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758088Ab3KHTML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:12:11 -0500
Date: Fri, 8 Nov 2013 11:12:09 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] OF: Introduce DT overlay support.
Message-ID: <20131108191209.GB25932@roeck-us.net>
References: <1383923170-24914-1-git-send-email-panto@antoniou-consulting.com>
 <1383923170-24914-3-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383923170-24914-3-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 05:06:09PM +0200, Pantelis Antoniou wrote:
> Introduce DT overlay support.
> Using this functionality it is possible to dynamically overlay a part of
> the kernel's tree with another tree that's been dynamically loaded.
> It is also possible to remove node and properties.
> 
> Note that the I2C client devices are 'special', as in they're not platform
> devices. They need to be registered with an I2C specific method.
> 
> In general I2C is just no good platform device citizen and needs
> special casing.
> 
> PCI is another special case where PCI device insertion and removal
> is implemented in the PCI subsystem.
> 
> Bug fixes & PCI support by Guenter Roeck <groeck@juniper.net>
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

Hi Pantelis,

another nitpick:

.git/rebase-apply/patch:195: trailing whitespace.
end up filling in the fields of the of_overlay_info array.
warning: 1 line adds whitespace errors.

Guenter
