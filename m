Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab3CPKez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 06:34:55 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43843 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab3CPKeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 06:34:50 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/6] OF: Export all DT proc update functions
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <1357327870-13615-4-git-send-email-panto@antoniou-consulting.com>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com> <1357327870-13615-4-git-send-email-panto@antoniou-consulting.com>
Date: Sat, 16 Mar 2013 09:45:56 +0000
Message-Id: <20130316094556.7898E3E09B0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Jan 2013 21:31:07 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
> There are other users for the proc DT functions.
> Export them.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

Hi Pantelis.

Patches 1 & 2 look good. No comments there.

This patch bothers me. The manipulation of the proc entries is part and
parcel of adding and removing nodes. The real problem seems to be that
the node addition/removal APIs need to be made usable by the overlay
code.

g.
