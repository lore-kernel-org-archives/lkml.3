Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab3KHTKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:10:44 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33501 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039Ab3KHTKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:10:42 -0500
Date: Fri, 8 Nov 2013 11:10:39 -0800
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
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/5] OF: Introduce utility helper functions
Message-ID: <20131108191039.GA25932@roeck-us.net>
References: <1383923040-24803-1-git-send-email-panto@antoniou-consulting.com>
 <1383923040-24803-6-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383923040-24803-6-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 05:04:00PM +0200, Pantelis Antoniou wrote:
> Introduce helper functions for working with the live DT tree.
> 
> __of_free_property() frees a dynamically created property
> __of_free_tree() recursively frees a device node tree
> __of_copy_property() copies a property dynamically
> __of_create_empty_node() creates an empty node
> __of_find_node_by_full_name() finds the node with the full name
> and
> of_multi_prop_cmp() performs a multi property compare but without
> having to take locks.
> 
> Bug fix about prop->len == 0 by Ionut Nicu <ioan.nicu.ext@nsn.com>
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

Hi Pantelis,

nitpick:

.git/rebase-apply/patch:77: trailing whitespace.
 * no pointer exist for any properties. Only safe to do if you
.git/rebase-apply/patch:213: trailing whitespace.
 * Find a node with the give full name by recursively following any of
.git/rebase-apply/patch:274: new blank line at EOF.
 +
warning: 3 lines add whitespace errors.

Guenter
