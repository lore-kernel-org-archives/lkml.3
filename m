Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaAMNV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:21:29 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:41353 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbaAMNV1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:21:27 -0500
Subject: Re: [PATCH] of: i2c: Export single device registration method
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20140113121739.GA2586@katana>
Date: Mon, 13 Jan 2014 15:21:17 +0200
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
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
        Matt Ranostay <mranostay@gmail.com>, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C80926F1-27C6-4F13-93BF-842E50D471DC@antoniou-consulting.com>
References: <1383674240-29491-1-git-send-email-panto@antoniou-consulting.com> <20140113121739.GA2586@katana>
To: Wolfram Sang <wsa@the-dreams.de>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Jan 13, 2014, at 2:17 PM, Wolfram Sang wrote:

> On Tue, Nov 05, 2013 at 07:57:20PM +0200, Pantelis Antoniou wrote:
>> Dynamically inserting i2c client device nodes requires the use
>> of a single device registration method. Rework and export it.
>> 
>> Don't be put off by the weird patch format, it's a simple move
>> of the operations applied on each device to a function.
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> 
> Are there public patches somewhere showing the use case of this patch?
> 

Of course.

> https://github.com/pantoniou/linux-beagle-track-mainline/blob/merge-min-20131105/drivers/of/overlay.c#L454

This is the how i2c DT overlays work, and is the method that the beaglebone releases work with i2c devices.

I am in the process of updating the patchset, but this part of the patch is unaffected.

Regards

-- Pantelis

