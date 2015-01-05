Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbbAEPAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:00:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbbAEPA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:00:28 -0500
Date: Mon, 5 Jan 2015 16:00:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Giel van Schijndel <me@mortis.eu>
Cc: linux-kernel@vger.kernel.org, Armin Schindler <mac@melware.de>,
        Karsten Keil <isdn@linux-pingi.de>,
        "open list:ISDN SUBSYSTEM" <netdev@vger.kernel.org>
Subject: Re: [PATCH] Fix NUL (\0 or \x00) specification in string
Message-ID: <20150105150026.GG6114@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Giel van Schijndel <me@mortis.eu>,
	linux-kernel@vger.kernel.org, Armin Schindler <mac@melware.de>,
	Karsten Keil <isdn@linux-pingi.de>,
	"open list:ISDN SUBSYSTEM" <netdev@vger.kernel.org>
References: <1420394722-20197-1-git-send-email-me@mortis.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420394722-20197-1-git-send-email-me@mortis.eu>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm replying to all your recent patches here as they are fixing things
reported in http://www.viva64.com/en/b/0299/ . I'ts a good practice to
give the credit the reporter.

The blogpost also contains analyses of the issues so it could help
reviewing the patches.
