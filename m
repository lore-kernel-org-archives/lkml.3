Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab3LLU2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:28:23 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:40087 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841Ab3LLU2W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:28:22 -0500
Subject: Re: [PATCH 2/3] OF: Add a allnodes pointer back to the tree
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20131212112047.87B5BC40637@trevor.secretlab.ca>
Date: Thu, 12 Dec 2013 22:28:14 +0200
Cc: Rob Herring <robherring2@gmail.com>,
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
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1F297430-16C1-406A-B93A-C39776FE16F6@antoniou-consulting.com>
References: <1386684833-24112-1-git-send-email-panto@antoniou-consulting.com > <1386684833-24112-3-git-send-email-panto@antoniou-consulting.com> <20131212112047.87B5BC40637@trevor.secretlab.ca>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Dec 12, 2013, at 1:20 PM, Grant Likely wrote:

> On Tue, 10 Dec 2013 16:13:52 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>> As it stands right now there's no way for a node to point back
>> to allnodes that the top level tree tracker for now.
>> 
>> This is problematic when using unflatten_dt_node more than once
>> because is leads to the nodes to be linked incorrectly.
>> 
>> Keep track of the root allnodes on each device_node and modify
>> unflaten_dt_node to match.
> 
> After our conversation on IRC and the decision to split unflattening the
> tree from attaching it to be visible to the entire kernel, I'm going to
> hold off on this patch. I suspect it will change in the process.
> 

OK,

I'm taking a look right now; should have something done on the weekend.

The whole idea is splitting unflattening from attaching to the live tree.

Should be straight forward enough.
 
> .
> 

Regards

-- Pantelis

