Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbaGUQDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:03:49 -0400
Received: from 8bytes.org ([81.169.241.247]:51582 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932543AbaGUQDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:03:47 -0400
Date: Mon, 21 Jul 2014 18:03:46 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140721160346.GP30979@8bytes.org>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
 <20140721120053.GA14069@amd.pavel.ucw.cz>
 <20140721123613.GL30979@8bytes.org>
 <20140721130629.GA15122@amd.pavel.ucw.cz>
 <20140721133800.GM30979@8bytes.org>
 <20140721141027.GA16042@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721141027.GA16042@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 21, 2014 at 04:10:27PM +0200, Pavel Machek wrote:
> > And Linux is only made for sane people? Thats pretty new to me ;-)
> 
> Yeah, but please don't optimize for insane people :-).

Thats rather discriminating, even more when you realize that 'insane' is
a very subjective attribute.

> #6 is bugfix. We should take it. Rest is performance improvement for
> insane config. I don't think we should take it.

Have you any other reason against these changes besides your
proven-to-be-wrong disbelief that it is necessary?


	Joerg

