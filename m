Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaJ2Czd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 22:55:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJ2Czb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 22:55:31 -0400
Date: Wed, 29 Oct 2014 10:54:18 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Joel Becker <jlbec@evilplan.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, linux-kernel@vger.kernel.org,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH] configfs: Implement binary attributes (v3)
Message-ID: <20141029025418.GA7842@kroah.com>
References: <1414528232-7707-1-git-send-email-pantelis.antoniou@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414528232-7707-1-git-send-email-pantelis.antoniou@konsulko.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 10:30:32PM +0200, Pantelis Antoniou wrote:
> ConfigFS lacked binary attributes up until now. This patch
> introduces support for binary attributes in a somewhat similar
> manner of sysfs binary attributes albeit with changes that
> fit the configfs usage model.
> 
> Problems that configfs binary attributes fix are everything that
> requires a binary blob as part of the configuration of a resource,
> such as bitstream loading for FPGAs, DTBs for dynamically created
> devices etc.

What's wrong with using the firmware interface for this instead?

What driver/subsystem wants to use configfs binary files?  Having a user
for this api is essential if you want it to be merged.

thanks,

greg k-h
