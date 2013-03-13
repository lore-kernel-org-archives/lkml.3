Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621Ab3CMOow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:44:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab3CMOov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:44:51 -0400
Date: Wed, 13 Mar 2013 15:44:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/5] HID: roccat: Removed actual profile from chardev
 reports
In-Reply-To: <1362915175.2769.167.camel@neuromancer.tessier-ashpool>
Message-ID: <alpine.LNX.2.00.1303131544210.26247@pobox.suse.cz>
References: <1362915175.2769.167.camel@neuromancer.tessier-ashpool>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Mar 2013, Stefan Achatz wrote:

> Userland-tools now keep track of actual profile themselves.
> Spared out Pyra, which is a harder case.

Hi Stefan,

I fail to see how this is not breaking backwards compatibility?

-- 
Jiri Kosina
SUSE Labs
