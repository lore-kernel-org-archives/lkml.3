Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaEDMZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 08:25:44 -0400
Received: from smtp.newterm.pl ([79.187.237.18]:56411 "EHLO apollo.newterm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbaEDMZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 08:25:43 -0400
Date: Sun, 4 May 2014 14:25:43 +0200
From: Darek Marcinkiewicz <reksio@newterm.pl>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/1] Driver for Beckhoff CX5020 EtherCAT master module.
Message-ID: <20140504122543.GF1156@newterm.pl>
References: <20140502175242.GB1156@newterm.pl>
 <20140503114029.GA19315@electric-eye.fr.zoreil.com>
 <20140504110413.GE1156@newterm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140504110413.GE1156@newterm.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2014 at 01:04:13PM +0200, Darek Marcinkiewicz wrote:
> > 
...
> attached to the EtherCAT bus. As for the locking on the tx path,
> I have removed that completely on receiving path. I simply didn't know 
...
Erm. I meant - I have removed it on the tx path. It was gone on rx
path already a few patch revs ago :)

-- 
DM
