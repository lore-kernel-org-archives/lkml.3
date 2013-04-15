Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab3DOPM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:12:26 -0400
Received: from ra.se.axis.com ([195.60.68.13]:58556 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab3DOPMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:12:25 -0400
Date: Mon, 15 Apr 2013 17:10:23 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CRIS: Remove last traces of legacy RTC drivers
Message-ID: <20130415151023.GI11974@axis.com>
References: <1363772628.1390.85.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363772628.1390.85.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 10:43:48AM +0100, Paul Bolle wrote:
> These legacy drivers were removed in commit
> 9c75fc8c5c8c50775fc8b89418219221335b758f ("CRIS: Remove legacy RTC
> drivers"). Now remove their last traces in two Kconfig files and one
> Makefile.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks, taken into the CRIS-tree.

(And again sorry for the late response)

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
