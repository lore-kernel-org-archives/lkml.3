Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3FNVLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:11:08 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:34284 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3FNVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:08:18 -0400
Message-ID: <1371244336.15314.112.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] target: don't corrupt bh_count in
 iscsit_stop_time2retain_timer()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
Date: Fri, 14 Jun 2013 14:12:16 -0700
In-Reply-To: <20130612171341.GA2981@logfs.org>
References: <20130530203651.GB13756@logfs.org>
	 <20130612171341.GA2981@logfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 13:13 -0400, Jörn Engel wrote:
> On Thu, 30 May 2013 16:36:51 -0400, Jörn Engel wrote:
> > 
> > I just started noticing this one.  Patch is completely untested so
> > far, so don't merge it just yet.  I just wanted early review,
> > considering how scary this looks.
> 
> Patch does fix a race we kept seeing at a low rate.  Nick, can you
> take it as-is?
> 

Mmmm, seems like a reasonable enough work-around for now..

Applied to target-pending/master, with a CC' to stable.

Thanks Joern!

--nab

